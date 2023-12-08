import React, { useState } from 'react';

export default function CreateNews() {
  const [newsData, setNewsData] = useState({
    title: '',
    content: '',
    imgUrl: '',
  });

  const handleChange = (e) => {
    const { name, value } = e.target;
    setNewsData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    // Handle the form submission, e.g., send data to the server or perform any other action
    console.log('Form submitted:', newsData);
  };

  return (
    <div className=" w-full mx-auto bg-white p-6 border-2 rounded-md shadow-md">
      <h2 className="text-2xl font-semibold mb-4">Create News</h2>
      <form onSubmit={handleSubmit}>
        <div className="mb-4">
          <label htmlFor="title" className="block text-gray-700 text-sm font-bold mb-2">
            Title:
          </label>
          <input
            type="text"
            id="title"
            name="title"
            value={newsData.title}
            onChange={handleChange}
            className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
            placeholder="Enter the news title"
          />
        </div>
        <div className="mb-4">
          <label htmlFor="content" className="block text-gray-700 text-sm font-bold mb-2">
            Content:
          </label>
          <textarea
            id="content"
            name="content"
            rows="4"
            value={newsData.content}
            onChange={handleChange}
            className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
            placeholder="Enter the news content"
          ></textarea>
        </div>
        <div className="mb-4">
          <label htmlFor="imgUrl" className="block text-gray-700 text-sm font-bold mb-2">
            Image URL:
          </label>
          <input
            type="text"
            id="imgUrl"
            name="imgUrl"
            value={newsData.imgUrl}
            onChange={handleChange}
            className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
            placeholder="Enter the image URL"
          />
        </div>
        <button
          type="submit"
          className="bg-blue-500 text-white px-4 py-2 rounded-md hover:bg-blue-700 focus:outline-none"
        >
          Add News
        </button>
      </form>
    </div>
  );
};
