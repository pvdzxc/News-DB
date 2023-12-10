import axios from "axios";
import React, { useState } from "react";
import Cookies from "universal-cookie"


const Login = () => {
    const [formData, setFormData] = useState({
        username: "",
        password: "",
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
            const response = await axios.post("http://localhost:9000/api/auth/login", formData);
      
            if (response.data.success) {
                const cookies = new Cookies();
                console.log(response.data.userInfo)
                cookies.set('isAuth', true, { path: '/' });
                cookies.set('user', response.data.userInfo.Username, { path: '/' });
                cookies.set('type', response.data.userInfo.UType, { path: '/' });
                console.log("User login successfully");
                setErr('');
                window.location.href = "http://localhost:3000/news"
              
            } else {
              console.error("Failed to login user:", response.data.message);
              setErr(response.data.message)
            }
          } catch (error) {
            console.error("Error during form submission:", error);
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
            <div className="flex justify-center">
                <button type="submit" className="bg-blue-500 text-white p-2 rounded-md">
                    Sign Up
                </button>
            </div>
        </form>
    );
};

export default Login;
