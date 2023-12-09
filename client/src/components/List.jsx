import React from "react";
import { Link } from "react-router-dom";

const List = ({ data }) => {
    const imgUrl = "https://images.unsplash.com/photo-1504253163759-c23fccaebb55?q=80&w=1000&auto=format&fit=crop&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxleHBsb3JlLWZlZWR8MXx8fGVufDB8fHx8fA%3D%3D"
    return (
        <div className="">
            {data.map(item => (
                <div key={item.id} className="rounded overflow-hidden shadow hover:shadow-2xl my-4">
                    <Link to={`/news-detail/${item.ArticleID}`} className="flex">
                        <img src={imgUrl} alt={item.ArTitle} className="w-48 h36 aspect-w-4 aspect-h-3 object-cover block my-4 mx-4" />
                        <div className="px-6 py-4 overflow-hidden">
                            <div className="font-bold text-xl text-blue1 mb-2">{item.ArTitle}</div>
                            <p className="text-bluelight text-base line-clamp-3">{item.ArContent}</p>
                        </div>
                    </Link>
                </div>
            ))}
        </div>
    );
}

export default List;