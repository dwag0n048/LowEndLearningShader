Its recommended to view it in the Code view instead of the Preview

# How is an image created?

## The big picture

Imagine Minecraft wants to render a single frame.

Your monitor runs at 60 Hz, for example.

That means:
60 Images per second                            16,67 ms
CPU → OpenGL → GPU → Monitor
⏱ Time budget per frame                       16,67 ms
»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»»
0 ms             60 FPS Goal                    16,67 ms

Thats everything Minecraft has for:
• calculating the World,
• updating the Mobs,
• making physics,
• and to render an complete Image.
Takes this more time, the FPS will go down.

------------------------------------------------------------------------------------------------------------------------------------------------------

## CPU vs GPU

This is the single most important foundation.

### CPU 
- Less strong Cores
- Logic, AI, Physic
- Good at complex decisions
- It struggles to calculate millions of pixels simultaneously

### GPU 
- Thousands of tiny Cores
- Pixels and Graphics
- Good for massive parallelism
- Able to calculate millions of pixels simultaneously

Try to Imagine 1 million Pixels

### CPU vs GPU with 1 million pixels

Illustration: The CPU operates with a few powerful cores, while the GPU works with thousands of small cores in parallel.

2200

                                ▩▩▩▩▩
                                ▩▩▩▩▩
1650                            ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
1100                            ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
550                             ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
                                ▩▩▩▩▩
0        _______                ▩▩▩▩▩
           CPU                    GPU
    8 Parallel Workers    2048 Parallel Workers

The GPU is like a giant factory with thousands of workers.
Each worker gets:
    "Calculate exactly one pixel."
And that happens simultaneously.
Thats why Shaders are so powerful.

------------------------------------------------------------------------------------------------------------------------------------------------------

## Everything is made of Triangles

### A Minecraft Block isn't really a cube

The GPU only knows:
• Points (Vertices)
• Lines
• Triangles

A block is built from 12 triangles.
Every triangle has 3 vertices. 

A vertex contains data such as:
Position: (x, y, z)
Texture: (u, v)
Color: (r, g, b)
Normal: (nx, ny, nz)
This data is called vertex attributes.

------------------------------------------------------------------------------------------------------------------------------------------------------

## The Rendering Pipeline

This is the path of a triangle through the GPU.

Vertices → Vertex Shader → Rasterizer → Fragment Shader → Framebuffer

We go through each station.

### 1. Vertices

Minecraft says:
"Here are the three points of a triangle."

As an example: 
A = (-1, 0, 0)
B = (1, 0, 0)
C = (0, 1, 0)

Thats just geometry.
Not an image yet.

### 2. Vertex Shader

Here runs for the first time the GLSL-Code,
The shader is executed for each vertex.
╔══════╦══════════════════════════════════════╗
║ glsl ║                                      ║
╠══════╝                                      ║
║                                             ║
║  void main() {                              ║
║      gl_Position = vec4(position, 1.0);     ║
║  }                                          ║
║                                             ║ 
╚═════════════════════════════════════════════╝

What happens here?
• position = Position of the vertex
• vec4(...) = 4D-Vector
• gl_Position = special output variable

The Vertex Shader can:
• move Objects
• scale
• rotate
• bend
• create waves

Water waves are often created right here!

### 3. Rasterizer 

Now the GPU magic happens.

The triangles become pixel candidates. 

The GPU asks:
    "Which pixels lie within this triangle?"
This is called rasterization.

### 4. Fragment Shader

The Fragment Shader runs for every single pixel.

At 1920×1080, that is:
        1920 × 1080 = 2073600
Over 2 Million executions per frame!

At 60 FPS:
        2.07M × 60 ≈ 124 Million shader executions per second

That is why shaders must be extremely efficient.

------------------------------------------------------------------------------------------------------------------------------------------------------

## A minimal Fragment Shader

╔══════╦════════════════════════════════════════╗
║ glsl ║                                        ║
╠══════╝                                        ║
║                                               ║
║  void main() {                                ║
║      gl_FragColor = vec4(1.0, 0.0, 0.0, 1.0); ║
║  }                                            ║
║                                               ║
╚═══════════════════════════════════════════════╝

That means:
• Red = 1.0
• Green = 0.0
• Blue = 0.0
• Alpha = 1.0

Every pixel turns red.

### Why is it being called vec4?

GLSL makes extensive use of vectors. 

Type:             Meaning:
=============================================
float            1 number
=============================================
vec2             2 numbers (x,y)
=============================================
vec3             3 numbers (x,y,z) or RGB
=============================================
vec4             4 numbers (x,y,z,w) or RGBA

Example:

╔══════╦════════════════════════════════════════╗
║ glsl ║                                        ║
╠══════╝                                        ║
║                                               ║
║  vec3 color = vec3(1.0, 0.5, 0.2);            ║
║                                               ║
╚═══════════════════════════════════════════════╝

This is: 
• Red = 1.0
• Green = 0.5
• Blue = 0.2

------------------------------------------------------------------------------------------------------------------------------------------------------

## The Framebuffer

The Fragment Shader writes its color to a memory area called the Framebuffer, its in the GPU memory.
This is where the calculated color of each pixel ends up before the image is displayed.
The image is sent to the monitor only when all the pixels are finished.