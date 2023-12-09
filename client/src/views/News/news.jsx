import React, { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import List from "../../components/List";
import Data from "./newsDataDummy";
import { Link } from "react-router-dom";
//import { getPropertyList } from "../../action/property.action";
export default function News() {
  const [propertyList, setPropertyList] = useState([]);
  //   const fetchData = async () => {
  //     try {
  //       const response = await getPropertyList();
  //       setPropertyList(response.data.propertyList);
  //     } catch (error) {
  //       console.error('Error fetching property list:', error);
  //     }
  //   };

  useEffect(() => {
    //fetchData();
    setPropertyList(Data);
  }, []);

  const customcss = `
    .icon
    {
        margin-right:20px;
    }
    .search
    {
        border-bottom: solid 1px #86BEC2;
    }
    .top
    {
        margin:70px 0px 60px 0px;
    }
    .bg-bluelight
    {
        padding: 10px 30px 10px 30px;
    }
    @media screen and (max-width: 1000px) {
      .grid {
          grid-template-columns: repeat(3, 1fr);
          gap: 10px;
      }
  }
  
  @media screen and (max-width: 768px) {
      .grid {
          grid-template-columns: repeat(2, 1fr);
          gap: 10px;
      }
  }
    `;
  return (
    <div className="flex-grow">
        <div className="flex justify-between top">
          <div className="flex items-center">
            <Link to={"/create-news"}>
              <button className="bg-bluelight hover:bg-blue1 text-white font-bold py-2 px-4 rounded">
                Create news
              </button>
            </Link>
          </div>
          <div className="flex items-center text-darkblue search">
            <form className="flex items-center text-darkblue">
              <span className="ml-2">
                <FaSearch className="text-bluelight icon" />
              </span>
              <input
                type="text"
                className="w-full focus:outline-none"
                placeholder="Search..."
              />
              <select name="sort" className="focus-visible:outline-none">
                  <option value={'datedes'} defaultChecked>Latest</option>
                  <option value={'dateacs'} >Oldest</option>
                  <option value={'viewdes'}>Most View</option>
                  <option value={'likedes'}>Most Like</option>
              </select>
            </form>
          </div>
        </div>
      <div className="flex justify-center">
      </div>

      {propertyList.length != 0 ? (
          <List data={propertyList} />
      ) : (
        <p className="flex justify-center">There is no property!!!</p>
      )}

      <style>{customcss}</style>
    </div>
  );
}
