/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package acesso;

import java.util.HashSet;

/**
 *
 * @author IE
 */
public abstract class KeyGenerator {
    private static final HashSet<Long> KEYS = new HashSet<>();
    /**
     * pode gerar chaves duplicadas
     * @param id1 um long qualquer, preferencilamente um id
     * @param id2 mesma coisa do id1
     * @return 
     */
    public synchronized static long generate(long id1, long id2){
        long key =  System.currentTimeMillis() - id1 - new Object().hashCode() -id2;
        if (!KEYS.add(key)) {
            return generate(id1, id2);
        }
        return key;
    }
    public synchronized static void removeKey(long key){
       KEYS.remove(key);
    }
}
