<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Number to Location Tracker</title>
    
    <!-- Leaflet CSS (The Map Styling) -->
    <link rel="stylesheet" href="https://unpkg.com/leaflet@1.9.4/dist/leaflet.css"
     integrity="sha256-p4NxAoJBhIIN+hmNHrzRCf9tD/miZyoHS5obTRR9BMY="
     crossorigin=""/>

    <style>
        body {
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            background-color: #f0f2f5;
            display: flex;
            flex-direction: column;
            align-items: center;
            padding: 20px;
        }

        .container {
            background: white;
            padding: 2rem;
            border-radius: 12px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
            width: 100%;
            max-width: 500px;
            text-align: center;
        }

        h1 { color: #333; margin-bottom: 20px; }

        .input-group {
            display: flex;
            gap: 10px;
            margin-bottom: 20px;
        }

        input {
            flex: 1;
            padding: 12px;
            border: 2px solid #ddd;
            border-radius: 6px;
            font-size: 16px;
        }

        button {
            padding: 12px 24px;
            background-color: #007bff;
            color: white;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            font-size: 16px;
            font-weight: bold;
            transition: background 0.3s;
        }

        button:hover { background-color: #0056b3; }

        #map {
            height: 350px;
            width: 100%;
            border-radius: 8px;
            border: 1px solid #ddd;
            margin-top: 10px;
        }

        .status {
            margin-top: 10px;
            font-size: 0.9em;
            color: #666;
        }
    </style>
</head>
<body>

    <div class="container">
        <h1>📍 Location Tracker</h1>
        <p>Enter a Zip Code or City Name to find the location.</p>
        
        <div class="input-group">
            <input type="text" id="locationInput" placeholder="e.g. 90210 or London">
            <button onclick="trackLocation()">Track</button>
        </div>

        <div id="map"></div>
        <div class="status" id="statusText">Waiting for input...</div>
    </div>

    <!-- Leaflet JS (The Map Logic) -->
    <script src="https://unpkg.com/leaflet@1.9.4/dist/leaflet.js"
     integrity="sha256-20nQCchB9co0qIjJZRGuk2/Z9VM+kNiyxNV1lvTlZBo="
     crossorigin=""></script>

    <script>
        // 1. Initialize the map
        // We start centered on the world (0,0) with zoom level 2
        var map = L.map('map').setView([20, 0], 2);

        // 2. Add the OpenStreetMap tiles (the visual map images)
        L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
            maxZoom: 19,
            attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
        }).addTo(map);

        var marker; // Variable to store our map pin

        // 3. The function to run when the button is clicked
        async function trackLocation() {
            const input = document.getElementById('locationInput').value;
            const status = document.getElementById('statusText');

            if (!input) {
                alert("Please enter a number or city name.");
                return;
            }

            status.innerText = "Searching...";

            try {
                // We use the Nominatim API (Free OpenStreetMap search)
                // This converts text (like "90210") into coordinates
                const response = await fetch(`https://nominatim.openstreetmap.org/search?format=json&q=${input}`);
                const data = await response.json();

                if (data && data.length > 0) {
                    const lat = data[0].lat;
                    const lon = data[0].lon;
                    const name = data[0].display_name;

                    // Remove old marker if it exists
                    if (marker) {
                        map.removeLayer(marker);
                    }

                    // Add new marker
                    marker = L.marker([lat, lon]).addTo(map)
                        .bindPopup(`<b>${name}</b><br>Lat: ${lat}<br>Lon: ${lon}`)
                        .openPopup();

                    // Fly the map to the location
                    map.flyTo([lat, lon], 13);
                    
                    status.innerText = `Found: ${name}`;
                } else {
                    status.innerText = "Location not found. Try a Zip Code or City.";
                }

            } catch (error) {
                console.error(error);
                status.innerText = "Error connecting to map service.";
            }
        }
    </script>
</body>
</html>
