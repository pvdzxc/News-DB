import React, { useState } from 'react';
import Data from '../views/News/newDataDummy';
const Comment = () => {
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
                    Leave a Comment:
                </label>
                <textarea
                    id="comment"
                    name="comment"
                    rows="4"
                    className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
                    placeholder="Write your comment here..."
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
        <div
        className="text-blue-500 cursor-pointer mt-2"
        onClick={handleLoadComments}
      >
        {showComments ? 'Hide Comments' : 'Load Comments'}
      </div>

      {/* Render Comments if showComments is true */}
      {showComments && (
        <div className="">
          {/* Render your comments here */}
            <div>
                <div className="border-2 border-gray-100 pb-4 mt-2 bg-gray-50 rounded-lg">
                    <div className='font-bold p-2'>{Data[1].aUsername}</div>
                    <div className='px-2'>{Data[1].arContent}</div>
                    
                </div>
                <div className="flex justify-end space-x-4 px-2 pt-2">
                    <span>{Data[1].arPublishDate}</span>
                    <button
                    onClick={() => handleLike(1)}
                    className="text-blue-500"
                    >
                    Like
                    </button>
                    <button
                    onClick={() => handleReply(1)}
                    className="text-blue-500"
                    >
                    Reply
                    </button>
                </div>
            </div>
            <div>
                <div className="border-2 border-gray-100 pb-4 mt-2 bg-gray-50 rounded-lg">
                    <div className='font-bold p-2'>{Data[1].aUsername}</div>
                    <div className='px-2'>{Data[1].arContent}</div>
                    
                </div>
                <div className="flex justify-end space-x-4 px-2 pt-2">
                    <span>{Data[1].arPublishDate}</span>
                    <button
                    onClick={() => handleLike(1)}
                    className="text-blue-500"
                    >
                    Like
                    </button>
                    <button
                    onClick={() => handleReply(1)}
                    className="text-blue-500"
                    >
                    Reply
                    </button>
                </div>
            </div>
            <div>
                <div className="border-2 border-gray-100 pb-4 mt-2 bg-gray-50 rounded-lg">
                    <div className='font-bold p-2'>{Data[1].aUsername}</div>
                    <div className='px-2'>{Data[1].arContent}</div>
                    
                </div>
                <div className="flex justify-end space-x-4 px-2 pt-2">
                    <span>{Data[1].arPublishDate}</span>
                    <button
                    onClick={() => handleLike(1)}
                    className="text-blue-500"
                    >
                    Like
                    </button>
                    <button
                    onClick={() => handleReply(1)}
                    className="text-blue-500"
                    >
                    Reply
                    </button>
                </div>
            </div>
            <div>
                <div className="border-2 border-gray-100 pb-4 mt-2 bg-gray-50 rounded-lg">
                    <div className='font-bold p-2'>{Data[1].aUsername}</div>
                    <div className='px-2'>{Data[1].arContent}</div>
                    
                </div>
                <div className="flex justify-end space-x-4 px-2 pt-2">
                    <span>{Data[1].arPublishDate}</span>
                    <button
                    onClick={() => handleLike(1)}
                    className="text-blue-500"
                    >
                    Like
                    </button>
                    <button
                    onClick={() => handleReply(1)}
                    className="text-blue-500"
                    >
                    Reply
                    </button>
                </div>
            </div>
          {/* Add more comments as needed */}
        </div>
      )}
    </div>
  );
};

export default Comment;
