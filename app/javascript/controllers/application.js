// This file is for Stimulus controllers setup
// Trix and ActionText are now handled in the main application.js

// Stimulus (якщо потрібно)
import { Application } from "@hotwired/stimulus";
const application = Application.start();
application.debug = false;
window.Stimulus = application;

// (за потреби) import "bootstrap";
