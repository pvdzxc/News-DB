import React from "react";
import { Link } from "react-router-dom";

const List = ({ data }) => {
    return (
        <div className="">
            {data.map(item => (
                <div key={item.id} className="rounded overflow-hidden shadow hover:shadow-2xl my-4">
                    <Link to={`/news-detail/${item.articleID}`} className="flex">
                        <img src={item.imgUrl} alt={item.arTitle} className="w-48 h36 aspect-w-4 aspect-h-3 object-cover block my-4 mx-4" />
                        <div className="px-6 py-4 overflow-hidden">
                            <div className="font-bold text-xl text-blue1 mb-2">{item.arTitle}</div>
                            <p className="text-bluelight text-base line-clamp-3">{item.arContent}</p>
                        </div>
                    </Link>
                </div>
            ))}
        </div>
    );
}

export default List;