package org.mirweb.spring_boot_demo;

import java.util.Map;

import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.ExampleObject;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import org.springframework.boot.info.BuildProperties;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api")
@Tag(name = "Info API", description = "Application build information")
class InfoController {

	private final BuildProperties buildProperties;

	InfoController(BuildProperties buildProperties) {
		this.buildProperties = buildProperties;
	}

	@GetMapping("/info")
	@Operation(summary = "Return application build info", description = "Returns the application name and version from build metadata.")
	@ApiResponses({
		@ApiResponse(responseCode = "200", description = "Build info returned", content = @Content(
			mediaType = "application/json",
			schema = @Schema(implementation = InfoResponse.class),
			examples = @ExampleObject(value = "{\"name\":\"spring-boot-demo\",\"version\":\"0.6.3\"}")
		))
	})
	public Map<String, String> info() {
		return Map.of(
			"name", buildProperties.getName(),
			"version", buildProperties.getVersion()
		);
	}

	record InfoResponse(
		@Schema(description = "Application name", example = "spring-boot-demo") String name,
		@Schema(description = "Application version", example = "0.6.3") String version
	) {
	}

}
