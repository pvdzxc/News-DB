import React, { useEffect, useState } from "react";
import { FaClock, FaFacebook, FaTwitter, FaTelegram } from "react-icons/fa";
import { useParams } from "react-router-dom";
import Comment from "../../components/Comment";
import axios from "axios";

export default function NewsDetail() {
    const {articleID} = useParams();
    console.log(articleID);
    const [article, setArticle] = useState();
    const [showComments, setShowComments] = useState(false);
    const fetchData = async () => {
        try {
          await axios.get(
              `http://localhost:9000/api/news/detail/${articleID}`,
              {
                headers: {
                  "Content-Type": "application/json",
                },
              }
            )
            .then((response) => {
                if(response.data.success){
                    console.log(response.data.article)
                    setArticle(response.data.article)
                } else{
                    console.log("Error:", response.data.message)
                }
            });
        } catch (error) {
          console.error("Error fetching article:", error);
        }
    };
    
      useEffect(() => {
        fetchData();
      }, []);

    if (!article) return (
    <div className="flex-grow">
        <h1>This article doesn't exist</h1>
    </div>)


    return (
        <div className="flex-grow max-w-2xl mx-auto">
            <h1 className="font-bold text-2xl my">{article.ArTitle}</h1>
            <div className="flex justify-between items-center mb-2 text-gray-500">
                <div className="flex">
                    <time className="flex text-sm items-center p-2"><FaClock className="mr-2"/> {new Date(article.ArPublishDate).toLocaleString()}</time>
                    <span className="p-2">{article.AUsername}</span>
                </div>
                <div className="flex">
                    <span className="p-2"><FaFacebook/></span>
                    <span className="p-2"><FaTwitter/></span>
                    <span className="p-2"><FaTelegram/></span>
                </div>
            </div>
            <div className="border rounded-lg">
                <div><img src={article.MLink} alt={article.ArTitle} className="w-full rounded-t-lg"/></div>
                <div className="mt-4 mb-6 px-4">
                    <p>{article.ArContent}</p>
                </div>
            </div>

            <div>
                <Comment articleID={articleID} />
            </div>
        </div>
    );
}
