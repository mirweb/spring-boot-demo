package org.mirweb.spring_boot_demo;

import java.util.Map;
import java.util.Optional;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.info.Info;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.context.annotation.Bean;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@SpringBootApplication
@RestController
@Tag(name = "Greeting API", description = "Simple endpoints for demo greeting responses")
public class SpringBootDemoApplication {

	private static final Logger logger = LoggerFactory.getLogger(SpringBootDemoApplication.class);

	public static void main(String[] args) {
		SpringApplication.run(SpringBootDemoApplication.class, args);
	}

	@Bean
	OpenAPI applicationOpenApi() {
		String version = Optional.ofNullable(SpringBootDemoApplication.class.getPackage().getImplementationVersion())
			.orElse("dev");
		return new OpenAPI().info(new Info()
			.title("spring-boot-demo API")
			.description("OpenAPI documentation for the demo Spring Boot backend.")
			.version(version));
	}

	@GetMapping("/api/hello")
	@Operation(summary = "Return a greeting message", description = "Returns a greeting for the provided name or defaults to World.")
	@ApiResponses({
		@ApiResponse(responseCode = "200", description = "Greeting generated", content = @Content(
			mediaType = "application/json",
			schema = @Schema(implementation = GreetingResponse.class),
			examples = @ExampleObject(value = "{\"message\":\"Hello Alice!\"}")
		))
	})
	public Map<String, String> hello(@RequestParam(value = "name", defaultValue = "World") String name) {
		logger.info("hello(name={})", name);
		return Map.of("message", "Hello %s!".formatted(name));
	}

	record GreetingResponse(
		@Schema(description = "Formatted greeting message", example = "Hello Alice!") String message
	) {
	}

}
