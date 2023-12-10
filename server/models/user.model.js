const connection = require("../config/database");
const bcrypt = require("bcrypt");

async function signUp(username, password, fullname, birthday) {
  try {
    // Hash the user's password
    const hashPassword = await bcrypt.hash(password, 10); // You can adjust the salt rounds as needed

    // Insert the user information into the database
    const [result] = await connection.execute(
      `
      INSERT INTO user (Username, UHasedPassword, UName, UBirthDate, UCreatedDate,ULastLogin, UType)
      VALUES (?, ?, ?, ?, ?, ?, ?)
    `,
      [username, hashPassword, fullname, birthday, new Date(), new Date(), 'Author' ]
    );

    // Check if the insertion was successful
    if (result.affectedRows > 0) {
      console.log("User registered successfully");
      return { success: true, message: "User registered successfully" };
    } else {
      console.log("Failed to register user");
      return { success: false, message: "Failed to register user" };
    }
  } catch (error) {
    console.error("Error during user registration:", error);
    throw error; // You might want to handle the error more gracefully
  }
}

async function userAlreadyExists(username) {
  try {
    // Query the database to check if the user already exists
    const [rows] = await connection.execute(
      'SELECT COUNT(*) as count FROM user WHERE Username = ?',
      [username]
    );

    // Extract the count from the result
    const userCount = rows[0].count;

    // Check if the count is greater than 0, indicating that the user already exists
    return userCount > 0;
  } catch (error) {
    console.error("Error checking user existence:", error);
    throw error; // You might want to handle the error more gracefully
  }
}

async function getUserInformation(username) {
    try {
      // Query the database to get user information
      const [rows] = await connection.execute(
        'SELECT * FROM user WHERE Username = ?',
        [username]
      );
  
      // Check if a user with the provided username exists
      if (rows.length > 0) {
        // Extract the user information from the result
        const userInformation = rows[0];
        return userInformation;
      } else {
        // User with the provided username doesn't exist
        console.log("User not found");
        return null;
      }
    } catch (error) {
      console.error("Error retrieving user information:", error);
      throw error; // You might want to handle the error more gracefully
    }
}


async function getAuthorInfo(username){
  try {
    // Query the database to get the hashed password for the provided username
    const [rows] = await connection.execute(
      'SELECT * FROM author WHERE AUsername = ?',
      [username]
    );

    // Check if a user with the provided username exists
    if (rows.length > 0) {
      const author = rows[0];
      return author;
    } else {
      // User with the provided username doesn't exist
      console.log("User not found");
      return { success: false, message: "User not found" };
    }
  } catch (error) {
    console.error("Error during login:", error);
    throw error; // You might want to handle the error more gracefully
  }
}


async function login(username, password) {
    try {
      // Query the database to get the hashed password for the provided username
      const [rows] = await connection.execute(
        'SELECT * FROM user WHERE Username = ?',
        [username]
      );
  
      // Check if a user with the provided username exists
      if (rows.length > 0) {
        const user = rows[0];
        
        // Compare the provided password with the hashed password stored in the database
        const passwordMatch = await bcrypt.compare(password, user.UHasedPassword);
  
        if (passwordMatch) {
          if(user.UType == 'Author'){
            const authorInfo = await getAuthorInfo(username);
            return { success: true, userInfo: user, authorID: authorInfo.AuthorID };
          }
          console.log("Login successful");
          return { success: true, userInfo: user };
        } else {
          // Passwords don't match, authentication failed
          console.log("Incorrect password");
          return { success: false, message: "Incorrect password" };
        }
      } else {
        // User with the provided username doesn't exist
        console.log("User not found");
        return { success: false, message: "User not found" };
      }
    } catch (error) {
      console.error("Error during login:", error);
      throw error; // You might want to handle the error more gracefully
    }
  }
  


module.exports = {
  signUp,
  userAlreadyExists,
  login,
  getUserInformation
};