import turtle
import moviepy.editor as mpy
from PIL import Image
import os


# Function to draw a heart with turtle and save frames
def draw_heart_and_save_frames(output_dir):
    if not os.path.exists(output_dir):
        os.makedirs(output_dir)

    window = turtle.Screen()
    window.bgcolor("white")
    t = turtle.Turtle()
    t.color("red")
    t.pensize(3)
    t.speed(0)

    frames = []
    step = 0

    t.penup()
    t.goto(0, -200)
    t.pendown()
    t.begin_fill()
    for i in range(180):
        t.left(1)
        t.forward(2)
        canvas = turtle.getcanvas()
        canvas.postscript(file=os.path.join(output_dir, "frame_{:03d}.eps".format(step)))
        step += 1
    t.end_fill()

    # Convert EPS files to PNG files
    for i in range(step):
        eps_file = os.path.join(output_dir, "frame_{:03d}.eps".format(i))
        png_file = os.path.join(output_dir, "frame_{:03d}.png".format(i))
        # Convert EPS to PNG using PIL
        with Image.open(eps_file) as img:
            img.save(png_file, 'png')
        frames.append(png_file)
        os.remove(eps_file)

    turtle.bye()
    return frames


# Create a video from frames
def create_video_from_frames(frames, output_file):
    clip = mpy.ImageSequenceClip(frames, fps=20)
    clip.write_videofile(output_file, codec="libx264")


if __name__ == "__main__":
    output_dir = "frames"
    output_file = "520_heart_video.mp4"

    # Draw heart and save frames
    frames = draw_heart_and_save_frames(output_dir)

    # Create video
    create_video_from_frames(frames, output_file)

    # Clean up frames
    for frame in frames:
        os.remove(frame)
    os.rmdir(output_dir)
