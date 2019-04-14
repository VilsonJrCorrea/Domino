package vilson;
import java.io.File;

import jacamo.infra.JaCaMoLauncher;
import jason.JasonException;
public class Run {

	public static void main(String args[]) {
		try {
			JaCaMoLauncher.main
			(new String[] { "vilson.jcm" 					});
		} catch (JasonException e) {
			System.out.println("Exception: "+e.getMessage());
			e.printStackTrace();
		}

	}
}