/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package interfaces;

import java.util.Observable;

/**
 *
 * @author IE
 */
public interface Subject {

    void register(Observable o);

    void unregister(Observable o);

    void notifyObserver();
}
