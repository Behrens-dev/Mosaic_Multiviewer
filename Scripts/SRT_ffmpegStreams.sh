ffmpeg \
-fflags nobuffer -rtsp_transport tcp -thread_queue_size 1024 -i rtsp://cam1 \
-fflags nobuffer -rtsp_transport tcp -thread_queue_size 1024 -i rtsp://cam2 \
-fflags nobuffer -rtsp_transport tcp -thread_queue_size 1024 -i rtsp://cam3 \
-fflags nobuffer -rtsp_transport tcp -thread_queue_size 1024 -i rtsp://cam4 \
 -filter_complex "
  [0:v]fps=15,scale=640:360[cam0];
  [1:v]fps=15,scale=640:360[cam1];
  [2:v]fps=15,scale=640:360[cam2];
  [3:v]fps=15,scale=640:360[cam3];
  [cam0][cam1][cam2][cam3]xstack=inputs=4:layout=0_0|w0_0|0_h0|w0_h0:shortest=1[v]
 " \
 -map "[v]" -fps_mode vfr -r 15 -pix_fmt yuv420p -color_range tv \
 -c:v libx264 -preset veryfast -tune zerolatency -b:v 2M -maxrate 2M -bufsize 4M \
 -f mpegts "srt://targetIP:9000?pkt_size=1316&mode=caller"
