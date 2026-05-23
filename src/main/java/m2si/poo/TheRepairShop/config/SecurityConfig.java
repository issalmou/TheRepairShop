package m2si.poo.TheRepairShop.config;

import m2si.poo.TheRepairShop.security.CustomUserDetailsService;
import m2si.poo.TheRepairShop.security.ForcePasswordChangeFilter;
import m2si.poo.TheRepairShop.security.CustomAuthenticationSuccessHandler;
import jakarta.servlet.DispatcherType;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.HttpMethod;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.dao.DaoAuthenticationProvider;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

@Configuration
@EnableWebSecurity
public class SecurityConfig {
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration)
            throws Exception {
        return configuration.getAuthenticationManager();
    }

    @Bean
    public SecurityFilterChain securityFilterChain(
            HttpSecurity http,
            CustomUserDetailsService customUserDetailsService,
            PasswordEncoder passwordEncoder,
            ForcePasswordChangeFilter forcePasswordChangeFilter,
            CustomAuthenticationSuccessHandler customAuthenticationSuccessHandler
    ) throws Exception {
        DaoAuthenticationProvider authenticationProvider =
                new DaoAuthenticationProvider(customUserDetailsService);
        authenticationProvider.setPasswordEncoder(passwordEncoder);

        http.authenticationProvider(authenticationProvider)
                .csrf(Customizer.withDefaults())
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.IF_REQUIRED))
                .addFilterBefore(forcePasswordChangeFilter, UsernamePasswordAuthenticationFilter.class)
                .authorizeHttpRequests(auth -> auth
                        .dispatcherTypeMatchers(DispatcherType.FORWARD).permitAll()
                        .requestMatchers(HttpMethod.GET, "/tracking", "/tracking/**").permitAll()
                        .requestMatchers(
                                "/login",
                                "/error",
                                "/css/**",
                                "/js/**",
                                "/images/**"
                        ).permitAll()
                        .requestMatchers("/users/owners/**").hasRole("ADMIN")
                        .requestMatchers("/shops/**", "/shops/new", "/users/manage/**")
                        .hasRole("OWNER")
                        .requestMatchers("/repairs/**", "/clients/**", "/devices/**", "/reports/**")
                        .hasAnyRole("OWNER", "REPARATEUR")
                        .requestMatchers("/dashboard").hasAnyRole("OWNER", "REPARATEUR")
                        .anyRequest().authenticated()
                )
                .formLogin(form -> form
                        .loginPage("/login")
                        .loginProcessingUrl("/login")
                        .successHandler(customAuthenticationSuccessHandler)
                        .failureHandler((request, response, exception) -> {
                            String errorType = "bad_credentials";
                            if (exception instanceof org.springframework.security.authentication.DisabledException) {
                                errorType = "disabled";
                            } else if (exception instanceof org.springframework.security.authentication.LockedException) {
                                errorType = "locked";
                            }
                            response.sendRedirect(request.getContextPath() + "/login?error=" + errorType);
                        })
                        .permitAll()
                )
                .logout(logout -> logout
                        .logoutUrl("/logout")
                        .logoutSuccessUrl("/login?logout")
                        .invalidateHttpSession(true)
                        .clearAuthentication(true)
                        .permitAll()
                );

        return http.build();
    }
}
