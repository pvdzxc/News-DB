import React, { useEffect, useState } from 'react';
import { Outlet } from "react-router-dom";
//import { authenticate } from "../../action/auth.action";
// import { useNavigate } from "react-router-dom";
// import Cookies from 'universal-cookie';
import Header from "../Header";

export default function UserLayout() {
//   const navigate = useNavigate();
  const [isAuth,setIsAuth] = useState(false);
  const [userType,setUserType] = useState('guest');
//   useEffect(()=>{
//     const cookies = new Cookies();
//     const token = cookies.get('token');
//     const userType = cookies.get('type');

//     authenticate(token)
//     .then(res => {
//       console.log(res);
//       setIsAuth(true);
//       setUserType(userType);
//     })
//     .catch(error => {
//       // console.log(error.response)
//       console.log(error);
//       navigate('/401');
//     })
//   }, [])


  return (
    <div className="container mx-auto max-w-4xl mb-16">
      <Header isLoggedIn={isAuth} userType={userType}/>
      <div className="flex-grow flex">
        <Outlet/>
      </div>
    </div>
  );
}