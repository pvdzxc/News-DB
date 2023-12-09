import React, { useState } from "react";
import { FaUser } from "react-icons/fa";

const ReviewItem = ({ review, edit }) => {
  const [isEditVisible, setIsEditVisible] = useState(false);

  const handleToggleEditVisibility = () => {
    setIsEditVisible(!isEditVisible);
  };

  return (
    <div className="">
        <div className=" mt-4 p-4 pt-4 mb-4">
                <h2 className="text-xl font-bold mb-4">{`Phase ${review.reviewPhase}`}</h2>
                <div className="flex">
                  <div className="text-2xl mr-2">
                    <FaUser></FaUser>
                  </div>
                  <div>
                    <div className="bg-gray-100 p-4 rounded-md">
                      <p>{review.reviewContent}</p>
                    </div>
                    <p className="text-sm text-gray-500 mb-2">{review.reviewDate}</p>
                  </div>
                </div>
            <button
                className="ml-6 text-blue-500 underline"
                onClick={handleToggleEditVisibility}
            >
                {isEditVisible ? "Hide Edit Log" : "Show Edit Log"}
            </button>

            {/* Edit Log (Conditional Rendering) */}
            {isEditVisible && (
                <div className="ml-6 mt-2 bg-gray-200 p-4 rounded-md">
                <p>{edit.editContent}</p>
                </div>
            )}
        </div>
    </div>
  );
};

export default ReviewItem;
