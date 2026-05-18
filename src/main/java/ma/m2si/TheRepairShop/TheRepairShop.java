package ma.m2si.TheRepairShop;

import ma.m2si.TheRepairShop.security.JwtAuthenticationFilter;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;

@SpringBootApplication
public class TheRepairShop {

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter() ;
    }

    public static void main(String[] args) {
        SpringApplication.run(TheRepairShop.class, args);
    }

}