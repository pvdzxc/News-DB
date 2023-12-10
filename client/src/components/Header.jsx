import React, { useEffect, useState } from "react";
import { Link } from "react-router-dom";
import Cookies from "universal-cookie"

const Header = ({isLoggedIn, type}) => {
  const cookies = new Cookies()
  const handleLogout = () => {  
    // Remove the cookies that were previously set
    cookies.remove('isAuth', { path: '/' });
    cookies.remove('user', { path: '/' });
    cookies.remove('type', { path: '/' });
    cookies.remove('authorID', { path: '/' });
    window.location.href = "http://localhost:3000/news"
  };
  const customstyle=
  {
    addborder:
    {
      border: '1px solid #013034',
      padding: '5px 20px 5px 20px',
      marginLeft: '15px',
    },
    header:
    {
      margin:'20px 0px 20px 40px',
    },
  };
  return (
      <header style={customstyle.header} className="border-b">
        <nav className="flex justify-end mb-2">
          <ul className="flex">
            <li>
              <button className="border-15 bg-white text-darkblue font-bold py-2 px-4 rounded">
                    <Link to="https://www.youtube.com/watch?v=dQw4w9WgXcQ">About Us</Link>
              </button>
            </li>
            <li>
              <button className="border-15 bg-white text-darkblue font-bold py-2 px-4 rounded">
                    <Link to="/news">News</Link>
              </button>
            </li>
            {type=="Editor" &&
              <li>
                <button className="border-15 bg-white text-darkblue font-bold py-2 px-4 rounded">
                      <Link to="/editor/news-management">News Management</Link>
                </button>
              </li>
            }
            {
              type=="Author" && 
              <li>
                <button className="border-15 bg-white text-darkblue font-bold py-2 px-4 rounded">
                      <Link to="/author/news-upload-history">News Upload History</Link>
                </button>
              </li>
            }
            
            {isLoggedIn ? (
              <li>
                <button className="border-15 border-darkblue bg-white text-darkblue font-bold py-2 px-4 rounded" onClick={handleLogout}>
                  Logout
                </button>
              </li>
            ) : (
              <>
                <li>
                  <button className="border-15 border-darkblue hover:bg-medium hover:text-white bg-white text-darkblue font-bold py-2 px-4 rounded addborder" style={customstyle.addborder}>
                    <Link to="signup">Sign Up</Link>
                  </button>
                </li>
                <li>
                  <button className="border-15 border-darkblue hover:bg-medium hover:text-white bg-white text-darkblue font-bold py-2 px-4 rounded addborder" style={customstyle.addborder}>
                    <Link to="login">Log In</Link>
                  </button>
                </li>
              </>
            )}
          </ul>
        </nav>
      </header>
  );
};

export default Header;