package ma.m2si.TheRepairShop.service;

import ma.m2si.TheRepairShop.dao.entity.User;
import ma.m2si.TheRepairShop.dao.repository.UserRepository;
import org.apache.commons.lang3.RandomStringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;

@Service
public class ForgotPasswordService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private JavaMailSender mailSender;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Value("${app.base.url}")
    private String baseUrl;

    private static final int TOKEN_EXPIRY_MINUTES = 30;
    private static final int TOKEN_LENGTH = 32;

    @Transactional
    public void sendResetToken(String email) {
        User user = userRepository.findByEmail(email)
                .orElseThrow(() -> new RuntimeException("Aucun compte trouvé avec cet email"));

        // Générer un token unique
        String token = generateToken();

        // Enregistrer le token dans la base de données
        user.setResetPasswordToken(token);
        user.setResetPasswordTokenExpiryDate(LocalDateTime.now().plusMinutes(TOKEN_EXPIRY_MINUTES));
        userRepository.save(user);

        // Envoyer l'email
        sendResetEmail(user.getEmail(), token);
    }

    private String generateToken() {
        return RandomStringUtils.randomAlphanumeric(TOKEN_LENGTH);
    }

    private void sendResetEmail(String email, String token) {
        String resetUrl = baseUrl + "/reset-password?token=" + token;

        SimpleMailMessage message = new SimpleMailMessage();
        message.setTo(email);
        message.setSubject("Réinitialisation de votre mot de passe - Repair Management System");
        message.setText(
                "Bonjour,\n\n" +
                        "Vous avez demandé la réinitialisation de votre mot de passe.\n\n" +
                        "Cliquez sur le lien ci-dessous pour réinitialiser votre mot de passe :\n" +
                        resetUrl + "\n\n" +
                        "Ce lien est valable pendant " + TOKEN_EXPIRY_MINUTES + " minutes.\n\n" +
                        "Si vous n'avez pas demandé cette réinitialisation, ignorez cet email.\n\n" +
                        "Cordialement,\n" +
                        "L'équipe Repair Management System"
        );

        mailSender.send(message);
    }

    @Transactional
    public void resetPassword(String token, String newPassword, String confirmPassword) {
        // Vérifier que les mots de passe correspondent
        if (!newPassword.equals(confirmPassword)) {
            throw new RuntimeException("Les mots de passe ne correspondent pas");
        }

        // Trouver l'utilisateur par token
        User user = userRepository.findByResetPasswordToken(token)
                .orElseThrow(() -> new RuntimeException("Token invalide"));

        // Vérifier si le token est expiré
        if (user.getResetPasswordTokenExpiryDate() == null ||
                user.getResetPasswordTokenExpiryDate().isBefore(LocalDateTime.now())) {
            throw new RuntimeException("Le token a expiré");
        }

        // Mettre à jour le mot de passe
        user.setPassword(passwordEncoder.encode(newPassword));
        user.setResetPasswordToken(null);
        user.setResetPasswordTokenExpiryDate(null);
        userRepository.save(user);
    }

    public boolean isValidToken(String token) {
        return userRepository.findByResetPasswordToken(token)
                .map(user -> user.getResetPasswordTokenExpiryDate() != null &&
                        user.getResetPasswordTokenExpiryDate().isAfter(LocalDateTime.now()))
                .orElse(false);
    }
}