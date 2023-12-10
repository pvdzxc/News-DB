import React, { useState } from 'react';
import axios from 'axios';
import { useEffect } from 'react';
import Cookies from 'universal-cookie';

export default function CreateNews() {
  const cookies = new Cookies();
  const [genre,setGenre] = useState([]);
  const [topic,setTopic] = useState([]);
  const [newsData, setNewsData] = useState({
    title: '',
    content: '',
    imgUrl: '',
    genre: '',
    topic: ''
  });
  const [err,setErr] = useState('');

  const handleChange = (e) => {
    const { name, value } = e.target;
    setNewsData((prevData) => ({
      ...prevData,
      [name]: value,
    }));
  };

  const handleSubmit = (e) => {
    e.preventDefault();
    try {
      axios.post("http://localhost:9000/api/news/createNews", {data: newsData, username: cookies.get('user')}, {
        headers: {
          "Content-Type": "application/json",
        },
      }).then((response)=>{
        if (response.data.success){
          console.log("Upload new news successfully");
          setErr('');
          window.location.href = "http://localhost:3000/news";
        } else {
          console.error("Failed to upload news:", response.data.message);
          setErr(response.data.message);
        }
      })
    } catch (error) {
      console.error("Error create news:", error);
    }





    
    console.log('Form submitted:', newsData);
  };

  useEffect(()=>{
    try {
      axios
        .get(
          `http://localhost:9000/api/news/news-genre`,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          setGenre(response.data.genre);
        });
    } catch (error) {
      console.error("Error fetching genre list:", error);
    }
    try {
      axios
        .get(
          `http://localhost:9000/api/news/news-topic`,
          {
            headers: {
              "Content-Type": "application/json",
            },
          }
        )
        .then((response) => {
          setTopic(response.data.topic);
        });
    } catch (error) {
      console.error("Error fetching topic list:", error);
    }
  },[]);

  return (
    <div className=" w-full mx-auto bg-white p-6 border-2 rounded-md shadow-md">
      <h2 className="text-2xl font-semibold mb-4">Create News</h2>
      {err!='' && <div className="text-red font-bold">
                Error: {err}
            </div>}
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
        <div className="mb-4">
          <label htmlFor="genre" className="block text-gray-700 text-sm font-bold mb-2">
            Genre:
          </label>
          <select
            id="genre"
            name="genre"
            value={newsData.genre}
            onChange={handleChange}
            className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
          >
            <option value="" disabled>Select a genre</option>
            {genre.map((genreItem) => (
              <option key={genreItem.GenreID} value={genreItem.GTitle}>
                {genreItem.GTitle}
              </option>
            ))}
          </select>
        </div>
        <div className="mb-4">
          <label htmlFor="topic" className="block text-gray-700 text-sm font-bold mb-2">
            Topic:
          </label>
          <select
            id="topic"
            name="topic"
            value={newsData.topic}
            onChange={handleChange}
            className="w-full border rounded-md px-3 py-2 focus:outline-none focus:border-blue-500"
          >
            <option value="" disabled>Select a topic</option>
            {topic.map((topicItem) => (
              <option key={topicItem.TopicID} value={topicItem.TpTitle}>
                {topicItem.TpTitle}
              </option>
            ))}
          </select>
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
