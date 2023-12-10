import React, { useEffect, useState } from "react";
import { FaClock, FaFacebook, FaTwitter, FaTelegram } from "react-icons/fa";
import Data from "./newsDataDummy";
import { useParams } from "react-router-dom";
import Comment from "../../components/Comment";
//import { getPropertyList } from "../../action/property.action";
export default function NewsDetail() {
    const {articleID} = useParams();
    console.log(articleID);
    const [article, setArticle] = useState();
    const [showComments, setShowComments] = useState(false);

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
        <div className="flex-grow max-w-2xl mx-auto">
            <h1 className="font-bold text-2xl my">{article.arTitle}</h1>
            <div className="flex justify-between items-center mb-2 text-gray-500">
                <div className="flex">
                    <time className="flex text-sm items-center p-2"><FaClock className="mr-2"/> {article.arPublishDate}</time>
                    <span className="p-2">{article.aUsername}</span>
                </div>
                <div className="flex">
                    <span className="p-2"><FaFacebook/></span>
                    <span className="p-2"><FaTwitter/></span>
                    <span className="p-2"><FaTelegram/></span>
                </div>
            </div>
            <div className="border rounded-lg">
                <div><img src={article.imgUrl} alt={article.arTitle} className="w-full rounded-t-lg"/></div>
                <div className="mt-4 mb-6 px-4">
                    <p>{article.arContent}</p>
                </div>
            </div>

            <div>
                <Comment></Comment>
            </div>
        </div>
    );
}
