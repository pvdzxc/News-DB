import React, { useEffect, useState } from 'react';
import { Outlet } from "react-router-dom";
import Header from "../Header";
import Cookies from "universal-cookie"

export default function UserLayout() {
  const cookies = new Cookies()
  const [isLoggedIn,setIsLoggedIn] = useState()
  const [type,setType] = useState()

  useEffect(() => {
    setIsLoggedIn(cookies.get('isAuth'))
    setType(cookies.get('type'))


  }, []);

  return (
    <div className="container mx-auto max-w-4xl mb-16">
      <Header isLoggedIn={isLoggedIn} type={type}/>
      <div className="flex-grow flex">
        <Outlet/>
      </div>
    </div>
  );
}