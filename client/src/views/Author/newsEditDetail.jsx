import React, { useEffect, useState } from "react";
import { reviewLogs, editLogs } from "../dummyLogData";
import Data from "../News/newsDataDummy";
import { useParams } from "react-router-dom";
import { FaClock, FaUser } from "react-icons/fa";
import Edit from "../../components/Edit";

const NewsEditDetail = () => {
  // Sample data for demonstration
  const {articleID} = useParams();
  const [article, setArticle] = useState();

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
        setArticle(Data.find(article => {
            return article.articleID==articleID
        }));
    }, []);
  
  if (!article) return (
    <div className="flex-grow">
        <h1>This article doesn't exist</h1>
    </div>)

  return (
    <div className="max-w-2xl mx-auto p-4">
      <h1 className="font-bold text-2xl my">{article.arTitle}</h1>
      <div className="flex justify-between items-center mb-2 text-gray-500">
          <div className="flex">
              <time className="flex text-sm items-center p-2"><FaClock className="mr-2"/> {article.arPublishDate}</time>
              <span className="p-2">{article.aUsername}</span>
          </div>
      </div>
      <div className="border rounded-lg">
          <div><img src={article.imgUrl} alt={article.arTitle} className="w-full rounded-t-lg"/></div>
          <div className="mt-4 mb-6 px-4">
              <p>{article.arContent}</p>
          </div>
      </div>
      <div className="flex justify-end mt-4">
        <button
          className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-700 focus:outline-none"
        >
          Edit
        </button>

      </div>
      <Edit></Edit>
    </div>
  );
};

export default NewsEditDetail;
