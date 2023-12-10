import React, { useEffect, useState } from "react";
import { reviewLogs, editLogs } from "../views/dummyLogData";
import Data from "../views/News/newsDataDummy";
import { useParams } from "react-router-dom";
import { FaClock, FaUser } from "react-icons/fa";
import ReviewItem from "./ReviewItem";
const Review = () => {
    const [showComments, setShowComments] = useState(false);

    const handleLoadComments = () => {
        setShowComments(!showComments);
    };

    const handleLike = (commentId) => {
        // Implement like functionality here (e.g., update likes in state)
        console.log(`Liked comment ${commentId}`);
    };

    const handleReply = (commentId) => {
        // Implement reply functionality here (e.g., open reply form)
        console.log(`Replying to comment ${commentId}`);
    };
    return (
    <div className="mt-4">
        <div>
            <form>
                <div className="mb-4">
                <label className="text-lg block text-gray-700 text-sm font-bold mb-2" htmlFor="comment">
                    Write Review:
                </label>
                <textarea
                    id="comment"
                    name="comment"
                    rows="4"
                    className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
                    placeholder="Write your review here..."
                ></textarea>
                </div>
                <div className="flex justify-end">
                    <button
                    type="submit"
                    className="bg-primary-500 text-white px-4 py-2 rounded-md hover:bg-primary-700 focus:outline-none"
                    >
                    Submit
                    </button>

                </div>
            </form>
        </div>
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

export default Review;
