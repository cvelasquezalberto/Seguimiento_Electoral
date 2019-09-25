package com.upc.denuncia.electoral.excepciones;

public class FileStorageException extends RuntimeException {
	public FileStorageException(String message) {
        super(message);
    }

    public FileStorageException(String message, Throwable cause) {
        super(message, cause);
    }
    
    /**
	 * 
	 */
	private static final long serialVersionUID = -1442244043068408385L;
}
