const  express = require('express');
const  bodyParser = require('body-parser');
const  helmet = require('helmet');
const  session = require('express-session');
const  cookieParser = require('cookie-parser');
const  cors = require('cors');

const newsRoute = require("./routes/news.route")
const authRoute = require("./routes/auth.route")

const  app = express();
// app.set('view engine', 'ejs');
app.use(bodyParser.json());
app.use(bodyParser.urlencoded({ extended: true }));
//app.use(helmet.contentSecurityPolicy(cspConfig));
app.use(express.static('assets'));
app.use(cors({ origin: "http://localhost:3000" }))
// app.use(cookieParser());
// app.use(session({
//   secret: "Your secret key",
//   resave: false,
//   saveUninitialized: true,
// }));

app.use("/api/auth", authRoute);
app.use("/api/news", newsRoute);


app.listen(9000);