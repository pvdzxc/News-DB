import React, { useEffect } from 'react';

const NewsReviewDetail = () => {
  // Sample data for demonstration

  useEffect(() => {
    const timeoutId = setTimeout(() => {
        window.location.href = 'https://www.youtube.com/watch?v=dQw4w9WgXcQ';
    }, 1000);
  
    // Clean up the timeout if the component is unmounted
    return () => clearTimeout(timeoutId);
  }, []);

  return (
    <div className="max-w-full overflow-x-auto">
      HELLO WORLD 
    </div>
  );
};

export default NewsReviewDetail;
