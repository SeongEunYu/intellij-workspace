package kr.co.argonet.r2rims.analysis.rawdata.module;

/**
 * <pre>
 * Rawdata 업데이트 관리를 위한 쓰레드클래스
 * </pre>
 * @date 2018. 08. 08.
 * @version
 * @author : woo
 */
public class RawdataUpdateThread implements Runnable{

	@Override
	public void run() {
		rawdataUpdate();
	}

	private void rawdataUpdate(){
		RawdataUpdate rawdataUpdate = new RawdataUpdate();
		rawdataUpdate.rawdataUpdate();
	}
}
