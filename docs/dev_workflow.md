

### **Smart Home**
#### 1. **Core Database**  
**Language:** C  
**Responsibilities:**  
- Handles data storage and retrieval using binary files.  
- Implements efficient memory management for performance.  
- Supports:
  - **Data rotation**: Archive or remove old data when storage exceeds a limit.  
  - **Indexing and searching**: Implement hash tables, B-trees, suitable algorithms...  
- **Custom data structures**: Design for flexibility and performance, based on sensor data types (e.g., integers, floats, timestamps).  
- **functions** `db_insert`, `db_query`, `db_delete`...  


#### 2. **REST API**  
**Language:** Python  
**Responsibilities:**  
- bridge between external devices/apps and the database.  
- Provides endpoints (Flask/FastAPI?) for:  
  - Storing data: `POST /data`  
  - Querying data: `GET /data`  
  - Managing the database: `DELETE /data`, 
  - ...
- Converts data to/from JSON for compatibility with sensors and apps.    
- Python bindings for C database library (`ctypes`/`cffi`?).  



#### 3. **System Integration**  
**Language Choice:** C  
**Responsibilities:**  
- Handles communication with sensors and forwards the data to the Raspberry Pi.  
- Intermediary layer, depending on sensor type and communication protocol (MQTT, HTTP, UART?).  


**External microcontroller collects data:**  lightweight program on the microcontroller to send data to the Raspberry Pi via (HTTP, MQTT...?)  

- **Communication protocol**...  


#### 4. **Frontend (Web/Desktop App)**  
**Language:** JavaScript, Electron (for Desktop App)  
**Responsibilities:**  
- Web-based or desktop interface for:  
  - Viewing and querying sensor data.  
  - Setting up thresholds, alerts, or configuration.  
  - Visualizing data (charts, tables).  

**Integration with REST API:**  
- (`fetch`/`axios`) in JS to call the REST API endpoints.  
- Display real-time updates using WebSockets or periodic polling.  


### **Integration Plan**
Here’s how the pieces work together:

1. **Sensors/Microcontrollers (C)**  
   - Collect real-world data (e.g., temperature, humidity).  
   - Transmit data to the Raspberry Pi 

2. **Raspberry Pi as Backend Hub**  
   - REST API (Python): Receives data from sensors and apps.  
   - Core database (C): Stores and retrieves data.  

3. **Frontend**  
   - Makes REST API calls to display or query data.  
   - Provides configuration options (sensor thresholds).



### **Tool/Library Recommendations**
#### **Core Database (C)**  
- File handling: (`fopen`, `fwrite`, `fread`) (binary file I/O).  
- Data structures: libraries  (`uthash`) (hash tables).  
- Memory debugging: `valgrind` for leak checks.  

#### **REST API (Python)**  
- Framework: **Flask** or **FastAPI**.  
- C integration: `ctypes`, `cffi`, or `cython`.  

#### **System Integration (Python or C)**  
- Serial communication: `termios` (C).  
- Networking: `paho-mqtt` (Python) or `libmosquitto` (C).  

#### **Frontend (JavaScript)**  
- Web UI: **React.js**, **Vue.js**, or plain JS.  
- Data visualization: **Chart.js**, **D3.js**.  
- Desktop app: **Electron.js**.



