package org.mirweb.spring_boot_demo;

import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
public class SpringBootDemoApplication {

	private static final Logger logger = LoggerFactory.getLogger(SpringBootDemoApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDemoApplication.class, args);
	}


	@GetMapping("/api/hello")
	public Map<String, String> hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		logger.info("hello(name={})", name);
		return Map.of("message", "Hello %s!".formatted(name));
	}

}
