import { useRoutes } from "react-router-dom";

//begin UserLayout layout
import UserLayout from "../Layout/UserLayout";
import News from "../../views/News/news";
import NewsDetail from "../../views/News/newsDetail";
import CreateNews from "../../views/Author/newsCreate";
import NewsManagement from "../../views/Editor/newsManagement";
import NewsReviewDetail from "../../views/Editor/newsReviewDetail";
import NewsUploadHistory from "../../views/Author/newsUploadHistory";
import NewsEditDetail from "../../views/Author/newsEditDetail";
//end UserLayout layout


//begin error layout
import ErrorLayout from "../Layout/ErrorLayout";
import Error401 from "../../views/Error/401";
import Error403 from "../../views/Error/403";
import Error404 from "../../views/Error/404";

//end erro layout

export default function Router() {
  const routes = useRoutes([
    {
      element: <UserLayout/>,
      children: [
        {element: <News />, index:true,},
        {path: 'news', element: <News/>},
        {path: 'news-detail/:articleID', element: <NewsDetail/>},
        {path: '/create-news', element: <CreateNews/>},
        {path: 'editor/news-management', element: <NewsManagement/>},
        {path: 'editor/review-details/:articleID', element: <NewsReviewDetail/>},
        {path: 'author/news-upload-history', element: <NewsUploadHistory/>},
        {path: 'author/edit-details/:articleID', element: <NewsEditDetail/>},
      ]
    },
    {
      element: <ErrorLayout/>,
      children: [
        {path: "401",element: <Error401/>},
        {path: "404", element: <Error404/>},
        {path: "403", element: <Error403/>},
      ]
    }
  ]);
  return routes;
}