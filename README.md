# VoxAi

VoxAi is a voice-powered AI assistant built with Jaspr, providing intuitive voice interactions for users.

## Overview

VoxAi  is a voice-powered AI assistant built with Jaspr, providing intuitive voice interactions for users. It leverages modern web technologies to create a responsive voice interface that can understand and respond to user commands. Built on the Jaspr framework, it offers a seamless experience across different devices.

## Features

- 🎤 Voice recognition and processing
- 💬 Natural language understanding
- 🤖 AI-powered responses
- 📱 Responsive design for all devices
- ⚡ Fast, client-side processing

## Getting Started
Demo : https://magnificent-marshmallow-62fc4c.netlify.app/
### Prerequisites

- Dart SDK (version 2.19 or higher)
- Jaspr CLI

### Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/chichimedamine/VoxAi.git
   cd voxai
   ```

2. Install dependencies:
   ```bash
   dart pub get
   ```

## Development

### Running the project

Run your project using the Jaspr CLI:

```bash
jaspr serve
```

The development server will be available on `http://localhost:8080`.

### Building the project

Build your project for production:

```bash
jaspr build
```

The output will be located inside the `build/jaspr/` directory.

## Project Structure

```
voxai/
├── lib/
│   ├── components/    # UI components
│   ├── models/        # Data models
│   ├── services/      # Business logic and API services
│   └── main.dart      # Entry point
├── public/            # Static assets
├── test/              # Test files
└── README.md          # This file
```


## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Acknowledgments

- [Jaspr Framework](https://github.com/schultek/jaspr)

