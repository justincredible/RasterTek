module Model (Model,initialize) where

import Graphics.GL
import Foreign.C.Types
import Foreign.Marshal.Alloc
import Foreign.Marshal.Array
import Foreign.Marshal.Utils
import Foreign.Ptr
import Foreign.Storable

import Flow.Render
import Flow.Shutdown
import Maths

data Model = Model {
    getVertexArray :: GLuint,
    getVertexBuffer :: GLuint,
    getIndexBuffer :: GLuint,
    getIndexCount :: GLsizei }
    deriving (Eq, Show)

initialize dataFile = do
    (numVertices,vertices) <- fmap read . readFile $ dataFile :: IO (Int,[GLfloat])
    let indices = [0..fromIntegral numVertices - 1] :: [GLuint]
        numIndices = numVertices
    
    vertexArray <- alloca $ (>>) . glGenVertexArrays 1 <*> peek
        
    glBindVertexArray vertexArray
    
    vertexBuffer <- alloca $ (>>) . glGenBuffers 1 <*> peek

    glBindBuffer GL_ARRAY_BUFFER vertexBuffer
    
    let vertexSize = sizeOf (head vertices)*quot (length vertices) numVertices
    withArray vertices $ \ptr ->
        glBufferData GL_ARRAY_BUFFER (fromIntegral $ numVertices*vertexSize) ptr GL_STATIC_DRAW

    glEnableVertexAttribArray 0
    
    glVertexAttribPointer 0 3 GL_FLOAT GL_FALSE (fromIntegral vertexSize) nullPtr
    
    indexBuffer <- alloca $ (>>) . glGenBuffers 1 <*> peek
    
    glBindBuffer GL_ELEMENT_ARRAY_BUFFER indexBuffer
    withArray indices $ \ptr ->
        glBufferData GL_ELEMENT_ARRAY_BUFFER (fromIntegral $ numIndices*sizeOf (head indices)) ptr GL_STATIC_DRAW
    
    glBindVertexArray 0
    
    return (True, Just $ Model vertexArray vertexBuffer indexBuffer (fromIntegral numIndices))

    where
    bufferOffset = plusPtr nullPtr . fromIntegral

instance Render Model where
    render model = do
        glBindVertexArray (getVertexArray model)
        
        glDrawElements GL_TRIANGLES (getIndexCount model) GL_UNSIGNED_INT nullPtr
        
        glBindVertexArray 0
        
        return (True,model)

instance Shutdown Model where
    shutdown (Model vArray vBuffer iBuffer _) = do
        glBindVertexArray vArray
        
        glDisableVertexAttribArray 0
        
        glBindBuffer GL_ELEMENT_ARRAY_BUFFER 0
        with iBuffer $ glDeleteBuffers 1
        
        glBindBuffer GL_ARRAY_BUFFER 0
        with vBuffer $ glDeleteBuffers 1
        
        glBindVertexArray 0
        with vArray $ glDeleteVertexArrays 1
