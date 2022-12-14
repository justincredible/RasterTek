module OpenGL(OpenGL,initialize,beginScene,endScene, getProjection, identityLH, translationLH, yRotationLH) where

import Foreign.Ptr
import Graphics.UI.GLFW
import Graphics.GL
import Graphics.Win32.GDI.Types

data OpenGL = OpenGL { getProjection :: [GLfloat] }
    deriving (Eq, Show)

initialize window width height = do
    glEnable GL_DEPTH_TEST
    glEnable GL_CULL_FACE
    
    swapInterval 1
    
    return . OpenGL $ perspectiveFovLH 0.785398163 (fromIntegral width/fromIntegral height) 0.1 1000

identityLH = take 16 . cycle $ [1,0,0,0,0]

perspectiveFovLH fieldOfView aspect near far = let
    rtfov = recip . tan . (*0.5) $ fieldOfView
    denom = far - near
    in
    [ rtfov*recip aspect, 0, 0, 0
    , 0, rtfov, 0, 0
    , 0, 0, far/denom, 1
    , 0, 0, negate $ far*near/denom, 0 ]

yRotationLH angle =
    [ cos angle, 0, -sin angle, 0
    , 0, 1, 0, 0
    , sin angle, 0, cos angle, 0
    , 0, 0, 0, 1 ]

translationLH x y z =
    [ 1, 0, 0, 0
    , 0, 1, 0, 0
    , 0, 0, 1, 0
    , x, y, z, 1 ]

beginScene red green blue alpha = do
    glClearColor red green blue alpha
    glClear (GL_COLOR_BUFFER_BIT + GL_DEPTH_BUFFER_BIT)

endScene window = do
    swapBuffers window
