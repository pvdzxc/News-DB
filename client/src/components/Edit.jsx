import React, { useEffect, useState } from "react";
import { reviewLogs, editLogs } from "../views/dummyLogData";
import Data from "../views/News/newsDataDummy";
import { useParams } from "react-router-dom";
import { FaClock, FaUser } from "react-icons/fa";
import ReviewItem from "./ReviewItem";
const Edit = () => {
    return (
    <div className="mt-4">
        {reviewLogs.map((review) => (
            <ReviewItem 
                key={review.id}
                review={review}
                edit={editLogs.find((edit)=> edit.editPhase==review.reviewPhase)}
            ></ReviewItem>
            
          ))}
    </div>
  );
};

export default Edit;