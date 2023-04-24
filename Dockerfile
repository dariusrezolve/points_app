#Use an official Elixir runtime as a parent image
FROM elixir:latest

# Set the working directory to /app
 WORKDIR /app

# # Copy the current directory contents into the container at /app
 COPY . /app

# # Install Hex package manager and Rebar build tool
 RUN mix local.hex --force && \
     mix local.rebar --force

#     # Install the project dependencies
     RUN mix deps.get
#
#     # Compile the project
     RUN mix compile

#     # Start the application
     CMD ["mix", "phx.server", "--no-halt"]
