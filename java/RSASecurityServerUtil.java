

import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.security.Key;
import java.security.KeyFactory;
import java.security.KeyPair;
import java.security.KeyPairGenerator;
import java.security.NoSuchAlgorithmException;
import java.security.SecureRandom;
import java.security.interfaces.RSAPrivateKey;
import java.security.interfaces.RSAPublicKey;
import java.security.spec.InvalidKeySpecException;
import java.security.spec.PKCS8EncodedKeySpec;
import java.security.spec.X509EncodedKeySpec;

import javax.crypto.Cipher;

// 引入参考http://blog.sina.com.cn/s/blog_5a6efa330102v8st.html
import sun.misc.BASE64Encoder;
import sun.misc.BASE64Decoder;
 
/**
 * 非对称加密算法RSA
 */
public class RSASecurityServerUtil {
	/** 指定加密算法为RSA */
	private static final String ALGORITHM = "RSA";
	/** 密钥长度，用来初始化 */
	private static final int KEYSIZE = 3072;
	/** 公钥 */
	private static Key publicKey = null;
	/** 私钥 */
	private static Key privateKey = null;
	/** 公钥字符串 */
	private static String publicKeyString = null;
	/** 私钥字符串 */
	private static String privateKeyString = null;
	/** 指定字符集 */
	private static String CHARSET = "UTF-8";
	/**
	 * RSA最大加密明文大小
	 */
	private static final int MAX_ENCRYPT_BLOCK = 117;
	/**
	 * RSA最大解密密文大小
	 */
	private static final int MAX_DECRYPT_BLOCK = 128;

	/**
	 * 生成密钥对
	 * 
	 * @throws Exception
	 */
	public static void generateKeyPair() throws Exception {

		// /** RSA算法要求有一个可信任的随机数源 */
		SecureRandom secureRandom = new SecureRandom();
		/** 为RSA算法创建一个KeyPairGenerator对象 */
		KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance(ALGORITHM);
		/** 利用上面的随机数据源初始化这个KeyPairGenerator对象 */
		keyPairGenerator.initialize(KEYSIZE, secureRandom);
		/** 生成密匙对 */
		KeyPair keyPair = keyPairGenerator.generateKeyPair();
		/** 得到公钥 */
		publicKey = keyPair.getPublic();
		BASE64Encoder encoder = new BASE64Encoder();
		publicKeyString = new String(encoder.encode(publicKey.getEncoded()));
		/** 得到私钥 */
		privateKey = keyPair.getPrivate();
		privateKeyString = new String(encoder.encode(privateKey.getEncoded()));
	}

	/**
	 * 生成公钥对象
	 * @param publicKeyStr
	 * @throws Exception
	 */
	public static void setPublicKey(String publicKeyStr) throws Exception {
		RSASecurityServerUtil.publicKey = generatePublicKey(publicKeyStr);
	}
	
	/**
	 * 生成私钥对象
	 * @param publicKeyStr
	 * @throws Exception
	 */
	public static void setPrivateKey(String privateKeyStr) throws Exception {
		RSASecurityServerUtil.privateKey = generatePrivateKey(privateKeyStr);
	}
	
	/**
	 * 私钥加密方法
	 * @param source源数据
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPrivateKey(String source,String privatekey) throws Exception {
		generatePrivateKey(privatekey);
		/** 得到Cipher对象来实现对源数据的RSA加密 */
		Cipher cipher = Cipher.getInstance(ALGORITHM);
		cipher.init(Cipher.ENCRYPT_MODE, privateKey);
		byte[] data = source.getBytes();
		/** 执行数据分组加密操作 */
		int inputLen = data.length;  
        ByteArrayOutputStream out = new ByteArrayOutputStream();  
        int offSet = 0;  
        byte[] cache;  
        int i = 0;  
        // 对数据分段加密  
        while (inputLen - offSet > 0) {  
            if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {  
                cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);  
            } else {  
                cache = cipher.doFinal(data, offSet, inputLen - offSet);  
            }  
            out.write(cache, 0, cache.length);  
            i++;  
            offSet = i * MAX_ENCRYPT_BLOCK;  
        }  
        byte[] encryptedData = out.toByteArray();  
        out.close();  
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(encryptedData);
	}

	/**
	 * 使用公钥解密算法
	 * @param cryptoSrc 密文
	 * @return
	 * @throws Exception
	 */
	public static String decryptByPublicKey(String cryptoSrc,String publicStr) throws Exception {
		setPublicKey(publicStr);
		/** 得到Cipher对象对已用公钥加密的数据进行RSA解密 */
		Cipher cipher = Cipher.getInstance(ALGORITHM);
		cipher.init(Cipher.DECRYPT_MODE, publicKey);
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] encryptedData = decoder.decodeBuffer(cryptoSrc);
		/** 执行解密操作 */
		
		int inputLen = encryptedData.length;  
        ByteArrayOutputStream out = new ByteArrayOutputStream();  
        int offSet = 0;  
        byte[] cache;  
        int i = 0;  
        // 对数据分段解密  
        while (inputLen - offSet > 0) {  
            if (inputLen - offSet > MAX_DECRYPT_BLOCK) {  
                cache = cipher.doFinal(encryptedData, offSet, MAX_DECRYPT_BLOCK);  
            } else {  
                cache = cipher.doFinal(encryptedData, offSet, inputLen - offSet);  
            }  
            out.write(cache, 0, cache.length);  
            i++;  
            offSet = i * MAX_DECRYPT_BLOCK;  
        }  
        byte[] decryptedData = out.toByteArray();  
        out.close();  
        
		return new String(decryptedData);
	}

	
	/**
	 * 公钥加密方法
	 * @param source源数据
	 * @return
	 * @throws Exception
	 */
	public static String encryptByPublicKey(String source, String pubString) throws Exception {
		setPublicKey(pubString);
		/** 得到Cipher对象来实现对源数据的RSA加密 */
		Cipher cipher = Cipher.getInstance(ALGORITHM);
		cipher.init(Cipher.ENCRYPT_MODE, publicKey);
		byte[] data = source.getBytes();
		/** 执行分组加密操作 */
		int inputLen = data.length;  
        ByteArrayOutputStream out = new ByteArrayOutputStream();  
        int offSet = 0;  
        byte[] cache;  
        int i = 0;  
        // 对数据分段加密  
        while (inputLen - offSet > 0) {  
            if (inputLen - offSet > MAX_ENCRYPT_BLOCK) {  
                cache = cipher.doFinal(data, offSet, MAX_ENCRYPT_BLOCK);  
            } else {  
                cache = cipher.doFinal(data, offSet, inputLen - offSet);  
            }  
            out.write(cache, 0, cache.length);  
            i++;  
            offSet = i * MAX_ENCRYPT_BLOCK;  
        }  
        byte[] encryptedData = out.toByteArray();  
        out.close();  
		
		BASE64Encoder encoder = new BASE64Encoder();
		return encoder.encode(encryptedData);
	}
	
	
	/**
	 * 私钥解密算法
	 * @param cryptoSrc 密文
	 * @return
	 * @throws Exception
	 */
	public static String decryptByPrivateKey(String cryptoSrc,String privatekey) throws Exception {
		//生成私钥对象
		setPrivateKey(privatekey);
		/** 得到Cipher对象对已用公钥加密的数据进行RSA解密 */
		Cipher cipher = Cipher.getInstance(ALGORITHM);
		cipher.init(Cipher.DECRYPT_MODE, privateKey);
		BASE64Decoder decoder = new BASE64Decoder();
		byte[] encryptedData = decoder.decodeBuffer(cryptoSrc);
        System.out.println(cryptoSrc);
        System.out.println(encryptedData);

		/** 执行解密操作 */
		int inputLen = encryptedData.length;  
        ByteArrayOutputStream out = new ByteArrayOutputStream();  
        int offSet = 0;  
        byte[] cache;  
        int i = 0;  
        // 对数据分段解密  
        while (inputLen - offSet > 0) {  
            if (inputLen - offSet > MAX_DECRYPT_BLOCK) {  
                cache = cipher.doFinal(encryptedData, offSet, MAX_DECRYPT_BLOCK);  
            } else {  
                cache = cipher.doFinal(encryptedData, offSet, inputLen - offSet);  
            }  
            out.write(cache, 0, cache.length);  
            i++;  
            offSet = i * MAX_DECRYPT_BLOCK;  
        }  
        byte[] decryptedData = out.toByteArray();  
        out.close();  
		return new String(decryptedData);
	}

//	/**
//	 * 私钥解密
//	 */
//	public static String decrypt(String cryptograph, String privateKeyStr) throws Exception {
//		/** 得到Cipher对象对已用公钥加密的数据进行RSA解密 */
//		Cipher cipher = Cipher.getInstance(ALGORITHM);
//		Key privateKey = generatePrivateKey(privateKeyStr);
//		cipher.init(Cipher.DECRYPT_MODE, privateKey);
//		BASE64Decoder decoder = new BASE64Decoder();
//		byte[] b1 = decoder.decodeBuffer(cryptograph);
//		/** 执行解密操作 */
//		byte[] b = cipher.doFinal(b1);
//		return new String(b);
//	}

	/**
	 * 将给定的公钥字符串转换为公钥对象
	 * 
	 * @param publicKeyStr
	 * @return
	 * @throws Exception
	 */
	private static Key generatePublicKey(String publicKeyStr) throws Exception {
		publicKeyString = publicKeyStr;
		try {
			BASE64Decoder base64Decoder = new BASE64Decoder();
			byte[] buffer = base64Decoder.decodeBuffer(publicKeyStr);
			KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
			X509EncodedKeySpec keySpec = new X509EncodedKeySpec(buffer);
			publicKey = (RSAPublicKey) keyFactory.generatePublic(keySpec);
			return publicKey;
		} catch (NoSuchAlgorithmException e) {
			throw new Exception("无此算法");
		} catch (InvalidKeySpecException e) {
			throw new Exception("公钥非法");
		} catch (IOException e) {
			throw new Exception("公钥数据内容读取错误");
		} catch (NullPointerException e) {
			throw new Exception("公钥数据为空");
		}
	}

	/**
	 * 将给定的私钥字符串转换为私钥对象
	 * 
	 * @param privateKeyStr
	 * @return
	 * @throws Exception
	 */
	private static Key generatePrivateKey(String privateKeyStr) throws Exception {
		privateKeyString = privateKeyStr;
		try {
			BASE64Decoder base64Decoder = new BASE64Decoder();
			byte[] buffer = base64Decoder.decodeBuffer(privateKeyStr);
			KeyFactory keyFactory = KeyFactory.getInstance(ALGORITHM);
			PKCS8EncodedKeySpec keySpec = new PKCS8EncodedKeySpec(buffer);
			privateKey = (RSAPrivateKey) keyFactory.generatePrivate(keySpec);
			return privateKey;
		} catch (NoSuchAlgorithmException e) {
			throw new Exception("无此算法");
		} catch (InvalidKeySpecException e) {
			throw new Exception("私钥非法");
		} catch (IOException e) {
			throw new Exception("私钥数据内容读取错误");
		} catch (NullPointerException e) {
			throw new Exception("私钥数据为空");
		}
	}

	public static String getPublicKeyString() {
		return publicKeyString;
	}

	public static String getPrivateKeyString() {
		return privateKeyString;
	}

	public static void generateKeyPair(String publicKeyStr, String privateKeyStr) throws Exception {
		generatePublicKey(publicKeyStr);
		generatePrivateKey(privateKeyStr);
	}

	public static void main(String[] args) throws Exception {
		generateKeyPair();
		System.out.println("公钥字符串: ");
		System.out.println(publicKeyString);
		System.out.println();
		System.out.println();
		System.out.println("公钥字符串长度" + publicKeyString.length());
		System.out.println();
		System.out.println();
		System.out.println("私钥字符串: ");
		System.out.println(privateKeyString);
		System.out.println();
		System.out.println();
		System.out.println("私钥字符串长度" + privateKeyString.length());
		System.out.println();
		System.out.println();
		System.out.println("公钥对象: ");
		System.out.println(publicKey);
		System.out.println();
		System.out.println();
		System.out.println("私钥对象: ");
		System.out.println(privateKey);
		int num = 0;
//		for (int i = 0; i< 100; i++ ) {
			String en = encryptByPrivateKey("123123", privateKeyString);
			System.out.println(en);
			System.out.println(decryptByPublicKey(en, publicKeyString));
			System.out.println(++ num);
//		}
		
	}
}
