package org.mirweb.spring_boot_demo;

import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.get;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.content;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.jsonPath;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.redirectedUrl;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.status;

import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.webmvc.test.autoconfigure.AutoConfigureMockMvc;
import org.springframework.context.annotation.Import;
import org.springframework.test.web.servlet.MockMvc;

@Import(TestcontainersConfiguration.class)
@SpringBootTest
@AutoConfigureMockMvc
class SpringBootDemoApplicationTests {

	@Autowired
	private MockMvc mockMvc;

	@Test
	void contextLoads() {
	}

	@Test
	void helloDefaultsToWorld() throws Exception {
		mockMvc.perform(get("/api/hello"))
			.andExpect(status().isOk())
			.andExpect(content().contentTypeCompatibleWith("application/json"))
			.andExpect(jsonPath("$.message").value("Hello World!"));
	}

	@Test
	void helloUsesNameQueryParam() throws Exception {
		mockMvc.perform(get("/api/hello").param("name", "Alice"))
			.andExpect(status().isOk())
			.andExpect(content().contentTypeCompatibleWith("application/json"))
			.andExpect(jsonPath("$.message").value("Hello Alice!"));
	}

	@Test
	void apiDocsExposeHelloEndpoint() throws Exception {
		mockMvc.perform(get("/v3/api-docs"))
			.andExpect(status().isOk())
			.andExpect(content().contentTypeCompatibleWith("application/json"))
			.andExpect(jsonPath("$.info.title").value("spring-boot-demo API"))
			.andExpect(jsonPath("$.paths['/api/hello'].get.summary").value("Return a greeting message"))
			.andExpect(jsonPath("$.paths['/api/hello'].get.parameters[0].name").value("name"));
	}

	@Test
	void swaggerUiIsExposed() throws Exception {
		mockMvc.perform(get("/swagger-ui.html"))
			.andExpect(status().is3xxRedirection())
			.andExpect(redirectedUrl("/swagger-ui/index.html"));
	}

}
