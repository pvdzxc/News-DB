import React, { useEffect, useState } from "react";
import { FaSearch } from "react-icons/fa";
import List from "../../components/List";
import { Link } from "react-router-dom";
import axios from "axios";
import Cookies from "universal-cookie"
//import { getPropertyList } from "../../action/property.action";
export default function News() {
  const cookies = new Cookies();
  const [type,setType] = useState('');
  const [newsList, setNewsList] = useState([]);

  const [sortValue, setSortValue] = useState("ArPublishDate-DESC");
  const handleSortChange = (event) => {
    setSortValue(event.target.value);
    fetchData();
  };

  const [searchValue, setSearchValue] = useState("");
  const handleSearchChange = (event) => {
    setSearchValue(event.target.value);
  };

  const handleSubmit = (event) => {
    event.preventDefault();
    // Call your fetchData function here with searchValue and sortValue
    fetchData();
  };

  const handleDelete = async (itemId) => {
    try {
      // Assuming itemId is the ID of the item you want to delete
      const response = await axios.delete(`http://localhost:9000/api/news/delete/${itemId}`, {
        headers: {
          "Content-Type": "application/json",
        },
      });
      if (response.data.success) {
        fetchData();
      } else {
        console.log(response.data.message);
      }
    } catch (error) {
      console.error('Error deleting item:', error);
    }
  };


  const fetchData = async () => {
    const [sort, order] = sortValue.split("-");
    try {
      axios
        .get(
          `http://localhost:9000/api/news/?search=${searchValue}&sort=${sort}&order=${order}`,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          console.log(response.data.newsList)
          setNewsList(response.data.newsList);
        });
    } catch (error) {
      console.error("Error fetching property list:", error);
    }
  };

  useEffect(() => {
    fetchData();
    setType(cookies.get('type'))
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
          {
            type == 'Author'&& 
            <Link to={"/create-news"}>
              <button className="bg-bluelight hover:bg-blue1 text-white font-bold py-2 px-4 rounded">
                Create news
              </button>
            </Link>
          }
        </div>
        <div className="flex items-center text-darkblue search">
          <form className="flex items-center text-darkblue" onSubmit={handleSubmit}>
            <span className="ml-2">
              <FaSearch className="text-bluelight icon" />
            </span>
            <input
              type="text"
              className="w-full focus:outline-none"
              placeholder="Search..."
              onChange={handleSearchChange}
            />
            <select
              name="sort"
              className="focus-visible:outline-none"
              value={sortValue}
              onChange={handleSortChange}
            >
              <option value={"ArPublishDate-DESC"} defaultChecked>
                Latest
              </option>
              <option value={"ArPublishDate-ASC"}>Oldest</option>
              <option value={"ArTotalViews-DESC"}>Most View</option>
              <option value={"ArTotalLikes-DESC"}>Most Like</option>
            </select>
          </form>
        </div>
      </div>
      <div className="flex justify-center"></div>

      {newsList && newsList.length != 0 ? (
        <List data={newsList} onDelete={handleDelete}/>
      ) : (
        
        <p className="flex justify-center">There is no news!!!</p>
      )}
      <style>{customcss}</style>
    </div>
  );
}
