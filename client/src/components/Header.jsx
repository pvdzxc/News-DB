import React from "react";
import { Link } from "react-router-dom";

const Header = ({ isLoggedIn, userType }) => {
  const renderUserOptions = () => {

    if (isLoggedIn) {
      if (userType === 'admin') {
        return (
          <button className="border-15 border-darkblue bg-white hover:text-white text-darkblue font-bold py-2 px-4 rounded">
            Manage Admin Account
          </button>
        );
      }
      else {
        return (
          <button className="border-15 border-darkblue bg-white hover:text-white text-darkblue font-bold py-2 px-4 rounded">
            Manage User Account
          </button>
        );
      }
    }
    return null;
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
            <li>
              <button className="border-15 bg-white text-darkblue font-bold py-2 px-4 rounded">
                    <Link to="/editor/news-management">News Management</Link>
              </button>
            </li>
            {isLoggedIn ? (
              <li>
                <button className="border-15 border-darkblue bg-white text-darkblue font-bold py-2 px-4 rounded">
                  Account
                </button>
                <div className="options">
                  {renderUserOptions()}
                </div>
              </li>
            ) : (
              <>
                <li>
                  <button className="border-15 border-darkblue hover:bg-medium hover:text-white bg-white text-darkblue font-bold py-2 px-4 rounded addborder" style={customstyle.addborder}>
                    <Link to="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Sign Up</Link>
                  </button>
                </li>
                <li>
                  <button className="border-15 border-darkblue hover:bg-medium hover:text-white bg-white text-darkblue font-bold py-2 px-4 rounded addborder" style={customstyle.addborder}>
                    <Link to="https://www.youtube.com/watch?v=dQw4w9WgXcQ">Log In</Link>
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