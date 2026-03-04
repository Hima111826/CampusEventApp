from flask import Flask, jsonify, request
from flask_cors import CORS
import json, os

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}) 


EVENTS_FILE = 'events.json'
USERS_FILE = 'users.json'
RSVP_FILE = 'rsvp.json'
FEEDBACK_FILE = 'feedback.json'

# -------------------------
# Helper Functions
# -------------------------
def read_json(file_path):
    if not os.path.exists(file_path):
        with open(file_path, 'w') as f:
            json.dump([], f)
        return []

    try:
        with open(file_path, 'r') as f:
            return json.load(f)
    except:
        return []

def write_json(file_path, data):
    with open(file_path, 'w') as f:
        json.dump(data, f, indent=4)

@app.before_request
def log_request():
    print("Incoming:", request.method, request.path)

# -------------------------
# LOGIN
# -------------------------
@app.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data provided'}), 400

    email = data.get('email')
    password = data.get('password')

    if not email or not password:
        return jsonify({'status': 'error', 'message': 'Missing email or password'}), 400

    users = read_json(USERS_FILE)

    for user in users:
        if user['email'] == email and user['password'] == password:
            return jsonify({
                'status': 'success',
                'role': user['role'],
                'email': user['email']
            })

    return jsonify({'status': 'error', 'message': 'Invalid credentials'}), 401

# -------------------------
# GET EVENTS
# -------------------------
@app.route('/events', methods=['GET'])
def get_events():
    return jsonify(read_json(EVENTS_FILE))

# -------------------------
# ADD EVENT
# -------------------------
@app.route('/events', methods=['POST'])
def add_event():
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data provided'}), 400

    title = data.get('title')
    description = data.get('description')
    date = data.get('date')

    if not title or not description or not date:
        return jsonify({'status': 'error', 'message': 'All fields required'}), 400

    events = read_json(EVENTS_FILE)
    event_id = max([e['id'] for e in events], default=0) + 1

    new_event = {
        'id': event_id,
        'title': title,
        'description': description,
        'date': date
    }

    events.append(new_event)
    write_json(EVENTS_FILE, events)

    return jsonify({'status': 'success', 'event': new_event}), 201

# -------------------------
# UPDATE EVENT
# -------------------------
@app.route('/events/<int:event_id>', methods=['PUT'])
def update_event(event_id):
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data provided'}), 400

    events = read_json(EVENTS_FILE)
    for event in events:
        if event['id'] == event_id:
            event['title'] = data.get('title', event['title'])
            event['description'] = data.get('description', event['description'])
            event['date'] = data.get('date', event['date'])

            write_json(EVENTS_FILE, events)
            return jsonify({'status': 'success', 'event': event})

    return jsonify({'status': 'error', 'message': 'Event not found'}), 404

# -------------------------
# DELETE EVENT
# -------------------------
@app.route('/events/<int:event_id>', methods=['DELETE'])
def delete_event(event_id):
    events = read_json(EVENTS_FILE)
    updated = [e for e in events if e['id'] != event_id]

    if len(events) == len(updated):
        return jsonify({'status': 'error', 'message': 'Event not found'}), 404

    write_json(EVENTS_FILE, updated)
    return jsonify({'status': 'success', 'message': 'Event deleted'})

# -------------------------
# RSVP
# -------------------------
@app.route('/rsvp', methods=['POST'])
def rsvp_event():
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data provided'}), 400

    email = data.get('email')
    event_id_raw = data.get('event_id')

    if not email or event_id_raw is None:
        return jsonify({'status': 'error', 'message': 'Missing fields'}), 400

    try:
        event_id = int(event_id_raw)
    except:
        return jsonify({'status': 'error', 'message': 'Invalid event_id'}), 400

    events = read_json(EVENTS_FILE)
    if not any(e['id'] == event_id for e in events):
        return jsonify({'status': 'error', 'message': 'Event not found'}), 404

    rsvps = read_json(RSVP_FILE)
    if any(r['email'] == email and r['event_id'] == event_id for r in rsvps):
        return jsonify({'status': 'error', 'message': 'Already registered'}), 400

    rsvps.append({'email': email, 'event_id': event_id})
    write_json(RSVP_FILE, rsvps)

    return jsonify({'status': 'success', 'message': 'Registered successfully'}), 201

# -------------------------
# VIEW REGISTRATIONS
# -------------------------
@app.route('/rsvp', methods=['GET'])
def view_registrations():
    rsvps = read_json(RSVP_FILE)
    events = read_json(EVENTS_FILE)
    result = []

    for r in rsvps:
        event = next((e for e in events if e['id'] == r['event_id']), None)
        if event:
            result.append({
                'email': r['email'],
                'event_id': r['event_id'],
                'event_title': event['title']
            })

    return jsonify(result)

# -------------------------
# FEEDBACK
# -------------------------
@app.route('/feedback', methods=['POST'])
def submit_feedback():
    data = request.get_json()
    if not data:
        return jsonify({'status': 'error', 'message': 'No data provided'}), 400

    email = data.get('email')
    event_id_raw = data.get('event_id')
    rating_raw = data.get('rating')
    comment = data.get('comment', '')

    try:
        event_id = int(event_id_raw)
        rating = int(rating_raw)
    except:
        return jsonify({'status': 'error', 'message': 'Invalid event_id or rating'}), 400

    if rating < 1 or rating > 5:
        return jsonify({'status': 'error', 'message': 'Rating must be 1-5'}), 400

    feedbacks = read_json(FEEDBACK_FILE)
    feedbacks.append({
        'email': email,
        'event_id': event_id,
        'rating': rating,
        'comment': comment
    })
    write_json(FEEDBACK_FILE, feedbacks)

    return jsonify({'status': 'success', 'message': 'Feedback submitted'}), 201

# -------------------------
# Test route
# -------------------------
@app.route("/", methods=["GET"])
def home():
    return "Server Working"

# -------------------------
# Error handler
# -------------------------
@app.errorhandler(500)
def handle_500(e):
    return jsonify({'status': 'error', 'message': 'Internal server error'}), 500

# -------------------------
# Run Flask server
# -------------------------
if __name__ == "__main__":
    app.run(host="0.0.0.0", port=5000, debug=True)