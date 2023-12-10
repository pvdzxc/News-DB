import axios from "axios";
import React, { useState } from "react";
import { useNavigate } from "react-router-dom";


const SignUp = () => {
    const navigate = useNavigate();
    const [formData, setFormData] = useState({
        username: "",
        password: "",
        email: "",
        fullName: "",
        birthDay: "",
    });

    const [err,setErr] = useState('');

    const handleChange = (e) => {
    const { name, value } = e.target;
        setFormData((prevData) => ({
            ...prevData,
            [name]: value,
        }));
    };

    const handleSubmit = async (e) => {
        e.preventDefault();
        try {
            // Add your form submission logic here
            const response = await axios.post("http://localhost:9000/api/auth/signup", formData);
      
            if (response.data.success) {
                setErr('');
                navigate('/login');
              
            } else {
              console.error("Failed to register user:", response.data.message);
              setErr(response.data.message)
            }
          } catch (error) {
            console.error("Error during form submission:", error);
            // Handle any errors that occurred during the form submission
          }
    };

    return (
        <form onSubmit={handleSubmit} className="max-w-md mx-auto mt-8">
            {err!='' && <div className="text-red font-bold">
                Error: {err}
            </div>}
            <div className="mb-4">
                <label
                htmlFor="username"
                className="block text-sm font-semibold text-gray-600"
                >
                Username
                </label>
                <input
                type="text"
                id="username"
                name="username"
                value={formData.username}
                onChange={handleChange}
                className="w-full p-2 border rounded-md"
                required
                />
            </div>

            <div className="mb-4">
                <label
                htmlFor="password"
                className="block text-sm font-semibold text-gray-600"
                >
                Password
                </label>
                <input
                type="password"
                id="password"
                name="password"
                value={formData.password}
                onChange={handleChange}
                className="w-full p-2 border rounded-md"
                required
                />
            </div>

            <div className="mb-4">
                <label
                htmlFor="fullName"
                className="block text-sm font-semibold text-gray-600"
                >
                Full Name
                </label>
                <input
                type="text"
                id="fullName"
                name="fullName"
                value={formData.fullName}
                onChange={handleChange}
                className="w-full p-2 border rounded-md"
                required
                />
            </div>

            <div className="mb-4">
                <label
                htmlFor="birthDay"
                className="block text-sm font-semibold text-gray-600"
                >
                Birth Day
                </label>
                <input
                type="date"
                id="birthDay"
                name="birthDay"
                value={formData.birthDay}
                onChange={handleChange}
                className="w-full p-2 border rounded-md"
                required
                />
            </div>
                
            <div className="flex justify-between">
                <button type="submit" className="bg-blue-500 text-white p-2 rounded-md">
                    Sign Up
                </button>
                <button type="cancel" className="bg-blue-500 text-white p-2 rounded-md">
                    Cancel
                </button>

            </div>
        </form>
    );
};

export default SignUp;
