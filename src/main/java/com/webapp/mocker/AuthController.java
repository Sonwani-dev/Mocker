package com.webapp.mocker;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Controller
public class AuthController {
    @Autowired
    private UserRepository userRepository;

    @GetMapping("/register")
    public String showRegisterForm() {
        return "register";
    }

    @PostMapping("/register")
    public String registerUser(@RequestParam String username,
                               @RequestParam String email,
                               @RequestParam String password,
                               @RequestParam String name,
                               Model model,
                               HttpSession session) {
        if (userRepository.findByUsername(username) != null || userRepository.findByEmail(email) != null) {
            model.addAttribute("error", "Username or email already exists");
            return "register";
        }
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPassword(password); // In production, hash the password!
        user.setName(name);
        userRepository.save(user);
        // Fetch the user again to ensure it's persisted and available
        User savedUser = userRepository.findByUsername(username);
        session.setAttribute("username", savedUser.getUsername());
        session.setAttribute("name", savedUser.getName());
        // Redirect to PE Subjects Dashboard after successful registration
        return "redirect:/pe-subjects";
    }

    @GetMapping("/login")
    public String showLoginForm(HttpSession session, HttpServletResponse response) {
        String username = (String) session.getAttribute("username");
        if (username != null) {
            return "redirect:/dashboard";
        }
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        return "login";
    }

    @PostMapping("/login")
    public String loginUser(@RequestParam String username,
                            @RequestParam String password,
                            Model model,
                            HttpSession session,
                            HttpServletRequest request,
                            HttpServletResponse response) {
        User user = userRepository.findByUsername(username);
        if (user == null || !user.getPassword().equals(password)) {
            return "redirect:/login?error=Invalid%20username%20or%20password";
        }
        session.setAttribute("username", username);
        session.setAttribute("name", user.getName());
        model.addAttribute("user", user);
        // Redirect to PE Subjects Dashboard after successful login
        return "redirect:/pe-subjects";
    }

    @RequestMapping(value = "/logout", method = RequestMethod.POST)
    public String logout(HttpSession session, jakarta.servlet.http.HttpServletResponse response) {
        session.invalidate();
        response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
        response.setHeader("Pragma", "no-cache");
        response.setDateHeader("Expires", 0);
        return "redirect:/login";
    }
} 