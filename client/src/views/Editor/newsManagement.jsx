import React, { useEffect, useState } from 'react';
import { Link } from "react-router-dom";
import axios from 'axios';

const NewsManagement = () => {
  // Sample data for demonstration
  const newsData = [
    {
        id: 1,
        authorName: 'John Doe',
        articleTitle: 'Lorem Ipsum',
        dateUpload: '2023-01-01',
        linkToDetail: 'review-details/1',
        phase: 'Pending',
        status: 'Upload',
    },
    {
        id: 2,
        authorName: 'John',
        articleTitle: 'Lorem Ipsum',
        dateUpload: '2023-01-01',
        linkToDetail: 'review-details/1',
        phase: 'Phase 1',
        status: 'Edit',
    },
    {
        id: 1,
        authorName: 'John Doe',
        articleTitle: 'Lorem Ipsum',
        dateUpload: '2023-01-01',
        linkToDetail: 'review-details/1',
        phase: 'Phase 2',
        status: 'Wait',
    },
    {
        id: 1,
        authorName: 'John Doe',
        articleTitle: 'Lorem Ipsum',
        dateUpload: '2023-01-01',
        linkToDetail: 'review-details/1',
        phase: 'Pending',
        status: 'Upload',
    }
    // Add more news data as needed
  ];

  return (
    <div className="max-w-full overflow-x-auto">
      <table className="min-w-full bg-white border border-gray-300">
        <thead>
          <tr>
            <th className="py-2 px-4 border-b">Author Name</th>
            <th className="py-2 px-4 border-b">Article Title</th>
            <th className="py-2 px-4 border-b">Date Upload</th>
            <th className="py-2 px-4 border-b">Link to Detail</th>
            <th className="py-2 px-4 border-b">Phase</th>
            <th className="py-2 px-4 border-b">Status</th>
            <th className="py-2 px-4 border-b">Action</th>
          </tr>
        </thead>
        <tbody>
          {newsData.map((news) => (
            <tr key={news.id} className='items-center border-b'>
              <td className="py-2 px-4 border-b">{news.authorName}</td>
              <td className="py-2 px-4 border-b">{news.articleTitle}</td>
              <td className="py-2 px-4 border-b">{news.dateUpload}</td>
              <td className="py-2 px-4 border-b">
                <a href={news.linkToDetail} className="text-blue-500">
                  View Detail
                </a>
              </td>
              <td className="py-2 px-4 border-b">{news.phase}</td>
              <td className="py-2 px-4 border-b">{news.status}</td>
              <td className="py-6 px-4 flex">
                <button className="bg-green-500 text-white px-3 py-1 rounded mr-2">
                  Accept
                </button>
                <button className="bg-red text-white px-3 py-1 rounded">
                  Reject
                </button>
              </td>
            </tr>
          ))}
        </tbody>
      </table>
    </div>
  );
};

export default NewsManagement;
