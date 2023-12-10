import React, { useEffect, useState } from 'react';
import Data from '../views/News/newsDataDummy';
import axios from 'axios';
import Cookies from 'universal-cookie';
const Comment = ({articleID}) => {
    const cookies = new Cookies();
    const username = cookies.get('user');
    const type = cookies.get('type');

    const [showComments, setShowComments] = useState(false);
    const [commentList,setCommentList] = useState([]);

    const fetchComment = async () => {
        try {
            axios
              .get(
                `http://localhost:9000/api/news/comment/${articleID}`,
                {
                  headers: {
                    "Content-Type": "application/json",
                  },
                }
              )
              .then((response) => {
                if (response.data.length!=0){
                    setCommentList(response.data.commentList[0]);
                }
                console.log(response.data.commentList[0])
              });
          } catch (error) {
            console.error("Error fetching property list:", error);
          }
    }

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

    useEffect(()=>{
        fetchComment()
    },[])


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
      {showComments && commentList.length > 0 && (
        <div className="">
            {commentList.map((comment, index) => (
            <div key={index}>
                <div className="border-2 border-gray-100 pb-4 mt-2 bg-gray-50 rounded-lg">
                <div className='font-bold p-2'>{comment.RUserName}</div>
                <div className='px-2'>{comment.CContent}</div>
                </div>
                <div className="flex justify-end space-x-4 px-2 pt-2">
                <span>{new Date(comment.CPostDate).toLocaleString()}</span>
                <button
                    onClick={() => handleLike(comment.CID)}
                    className="text-blue-500"
                >
                    Like
                </button>
                <button
                    onClick={() => handleReply(comment.CID)}
                    className="text-blue-500"
                >
                    Reply
                </button>
                </div>
            </div>
            ))}
        </div>
        )}
    </div>
  );
};

export default Comment;
