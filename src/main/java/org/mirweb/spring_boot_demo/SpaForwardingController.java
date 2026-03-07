package org.mirweb.spring_boot_demo;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
class SpaForwardingController {

	@GetMapping({"/", "/app/**"})
	String forwardToIndex() {
		return "forward:/index.html";
	}
}
