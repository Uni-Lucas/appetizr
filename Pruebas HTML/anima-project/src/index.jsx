import React from "react";
import ReactDOMClient from "react-dom/client";
import { PropietarioPagina } from "./screens/PropietarioPagina";

const app = document.getElementById("app");
const root = ReactDOMClient.createRoot(app);
root.render(<PropietarioPagina />);
