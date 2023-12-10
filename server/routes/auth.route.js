const express = require("express");
const router = express.Router();
const bcrypt = require("bcrypt");

const {
  signUp,
  userAlreadyExists,
  login,
  getUserInformation,
} = require("../models/user.model");

const validateUserInformation = (username, password, fullName, birthDay) => {
  if (!username || !password || !fullName || !birthDay) {
    return { success: false, message: "All fields are required" };
  }

  // Add additional validation checks as needed

  return { success: true };
};

// Endpoint for user registration
router.post("/signup", async (req, res) => {
  try {
    const { username, password, fullName, birthDay } = req.body;

    // Validate user information
    const validationCheck = validateUserInformation(
      username,
      password,
      fullName,
      birthDay
    );

    if (!validationCheck.success) {
      return res.json(validationCheck);
    }

    // Check if the user already exists
    const doesUserExist = await userAlreadyExists(username);

    if (doesUserExist) {
      return res
        .json({ success: false, message: "User already exists" });
    }

    // Register the user
    const registrationResult = await signUp(
      username,
      password,
      fullName,
      birthDay
    );

    if (registrationResult.success) {
      res.json({ success: true, message: "User registered successfully" });
    } else {
      res
        .json({ success: false, message: "Failed to register user" });
    }
  } catch (error) {
    console.error("Error during user registration:", error);
    res.json({ success: false, message: "Internal Server Error" });
  }
});

// Endpoint for user login
router.post("/login", async (req, res) => {
  try {
    const { username, password } = req.body;

    // Perform login
    const loginResult = await login(username, password);

    if (loginResult.success) {
      res.json({ success: true, message: "Login successful", userInfo: loginResult.userInfo });
    } else {
      res.json({ success: false, message: "Invalid user credentials" });
    }
  } catch (error) {
    console.error("Error during login:", error);
    res.json({ success: false, message: "Internal Server Error" });
  }
});

// Endpoint to get user information
router.get("/user/:username", async (req, res) => {
  try {
    const { username } = req.params;

    // Get user information
    const userInformation = await getUserInformation(username);

    if (userInformation) {
      res.json({ success: true, user: userInformation });
    } else {
      res.status(404).json({ success: false, message: "User not found" });
    }
  } catch (error) {
    console.error("Error retrieving user information:", error);
    res.status(500).json({ success: false, message: "Internal Server Error" });
  }
});

module.exports = router;
