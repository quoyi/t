// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

// Stylesheets
import "../stylesheets/application";

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"

Rails.start()
Turbolinks.start()
ActiveStorage.start()

import '@fortawesome/fontawesome-free/js/all';
import 'bootstrap/dist/js/bootstrap';
// import "stickyfilljs/dist/stickyfill";
import "sticky-kit/dist/sticky-kit";
// import "is_js/is";
// import "lodash/lodash";
// import "perfect-scrollbar/dist/perfect-scrollbar";
// import "chart.js/dist/Chart";
import "datatables/media/js/jquery.dataTables";
import "datatables.net-bs4/js/dataTables.bootstrap4";
import "datatables.net-responsive/js/dataTables.responsive";
import "datatables.net-responsive-bs4/js/responsive.bootstrap4";
import "leaflet/dist/leaflet";
import "leaflet.markercluster/dist/leaflet.markercluster";
import "leaflet.tilelayer.colorfilter/src/leaflet-tilelayer-colorfilter";
import "owl.carousel/dist/owl.carousel"; // 目前仅静态页面使用

import "./theme";
import "./events";
