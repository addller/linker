PGDMP     ,                    v            linker    10.1    10.1 �    !           0    0    ENCODING    ENCODING        SET client_encoding = 'UTF8';
                       false            "           0    0 
   STDSTRINGS 
   STDSTRINGS     (   SET standard_conforming_strings = 'on';
                       false            #           1262    17566    linker    DATABASE     �   CREATE DATABASE linker WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'Portuguese_Brazil.1252' LC_CTYPE = 'Portuguese_Brazil.1252';
    DROP DATABASE linker;
             postgres    false                        2615    2200    public    SCHEMA        CREATE SCHEMA public;
    DROP SCHEMA public;
             postgres    false            $           0    0    SCHEMA public    COMMENT     6   COMMENT ON SCHEMA public IS 'standard public schema';
                  postgres    false    4                        3079    12924    plpgsql 	   EXTENSION     ?   CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;
    DROP EXTENSION plpgsql;
                  false            %           0    0    EXTENSION plpgsql    COMMENT     @   COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';
                       false    1                        3079    17614    citext 	   EXTENSION     :   CREATE EXTENSION IF NOT EXISTS citext WITH SCHEMA public;
    DROP EXTENSION citext;
                  false    4            &           0    0    EXTENSION citext    COMMENT     S   COMMENT ON EXTENSION citext IS 'data type for case-insensitive character strings';
                       false    2                       1255    18462 6   _atualizaravaliacaocomentario(bigint, bigint, boolean)    FUNCTION     �  CREATE FUNCTION _atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_comentario where avaliacao_comentario.id = _id_avaliacao_comentario limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where comentario.id = _id_comentario;
            elsif(not _is_positiva and preAvaliacao) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where comentario.id = _id_comentario;
            else
            	if(_is_positiva) then
                	update comentario set avaliacoes_positivas = avaliacoes_positivas - 1 where comentario.id = _id_comentario;
                else
                	update comentario set avaliacoes_negativas = avaliacoes_negativas - 1 where comentario.id = _id_comentario;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_comentario set is_positiva = _is_positiva where avaliacao_comentario.id = _id_avaliacao_comentario;
            return 'TROCA';
		end
    $$;
 �   DROP FUNCTION public._atualizaravaliacaocomentario(_id_avaliacao_comentario bigint, _id_comentario bigint, _is_positiva boolean);
       public       postgres    false    4    1                        1255    18472 4   _atualizaravaliacaopostagem(bigint, bigint, boolean)    FUNCTION     `  CREATE FUNCTION _atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean) RETURNS text
    LANGUAGE plpgsql
    AS $$
    	declare
            preAvaliacao boolean;
    	begin 
        	select is_positiva into preAvaliacao from avaliacao_postagem where avaliacao_postagem.id = _id_avaliacao_postagem limit 1;
        	if(_is_positiva and not preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas + 1, avaliacoes_negativas = avaliacoes_negativas - 1
                	where postagem.id = _id_postagem;
            elsif(not _is_positiva and preAvaliacao) then
            	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1, avaliacoes_negativas = avaliacoes_negativas + 1
                	where postagem.id = _id_postagem;
            else
            	if(_is_positiva) then
                	update postagem set avaliacoes_positivas = avaliacoes_positivas - 1 where postagem.id = _id_postagem;
                else
                	update postagem set avaliacoes_negativas = avaliacoes_negativas - 1 where postagem.id = _id_postagem;
                end if;
             	return 'REMOVE';
            end if;
            update avaliacao_postagem set is_positiva = _is_positiva where avaliacao_postagem.id = _id_avaliacao_postagem;
            return 'TROCA';
		end
    $$;
 |   DROP FUNCTION public._atualizaravaliacaopostagem(_id_avaliacao_postagem bigint, _id_postagem bigint, _is_positiva boolean);
       public       postgres    false    1    4            �            1255    18441 6   _denunciar(bigint, bigint, integer, character varying)    FUNCTION     -  CREATE FUNCTION _denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
            suspensa boolean;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ) as id; 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
             suspensa = total_denuncias > 49;
            if(suspensa) then
            	update postagem set is_suspensa = true;
            end if;
           	return query select newId, suspensa;        
		end
    $$;
 �   DROP FUNCTION public._denunciar(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    4    1                       1255    18417 g   _editar_perfil(bigint, character varying, date, character, character varying, bytea, character varying)    FUNCTION     �  CREATE FUNCTION _editar_perfil(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying) RETURNS void
    LANGUAGE plpgsql
    AS $$
    begin
    	update membro set 
        	login_name = _login_name,
            pass = _pass,
            email = _email, 
            sexo = _sexo,
            nascimento = _nascimento,
            nome = _nome
  				where membro.id = _id_membro;
    	end
    $$;
 �   DROP FUNCTION public._editar_perfil(_id_membro bigint, _nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying);
       public       postgres    false    4    1            
           1255    18456 -   _if_ternario(boolean, anyelement, anyelement)    FUNCTION     �   CREATE FUNCTION _if_ternario(boolean, anyelement, anyelement) RETURNS anyelement
    LANGUAGE sql
    AS $_$
  select case when $1 is true then $2 else $3 end;
$_$;
 D   DROP FUNCTION public._if_ternario(boolean, anyelement, anyelement);
       public       postgres    false    4            %           1255    18423     _logar(character varying, bytea)    FUNCTION     \  CREATE FUNCTION _logar(_login_name character varying, _pass bytea) RETURNS TABLE(_id bigint, _nome character varying, _nascimento date, _sexo character)
    LANGUAGE plpgsql
    AS $$
    begin
    	return query select id, nome::character varying, nascimento, sexo::char from membro where login_name = _login_name and pass = _pass;
    end
    $$;
 I   DROP FUNCTION public._logar(_login_name character varying, _pass bytea);
       public       postgres    false    4    1                       1255    18405 �   _postar(character varying, character varying[], character varying[], character varying[], character varying, character varying, character varying, integer, bigint)    FUNCTION        CREATE FUNCTION _postar(_descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _palavra_chave character varying, _titulo character varying, _patrocinador character varying, _id_classificacao_etaria integer, _id_membro_postante bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		new_postagem bigint;
            _inscrito bigint;
    	begin
        	select id into new_postagem from registrarPostagem(
    			_descricao,
    			_vetor_url_site,
    			_vetor_url_video,
    			_vetor_url_imagem,
    			_palavra_chave,
    			_titulo,
    			_patrocinador,
    			_id_classificacao_etaria,
    			_id_membro_postante
    		) as id;
            
            for _inscrito in select id_registrado from inscrito where id_registrando = _id_membro_postante loop
            	perform registrarNotificacaoPostagem(_inscrito,new_postagem);
            end loop;             
			return new_postagem;         
		end
    $$;
 J  DROP FUNCTION public._postar(_descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _palavra_chave character varying, _titulo character varying, _patrocinador character varying, _id_classificacao_etaria integer, _id_membro_postante bigint);
       public       postgres    false    4    1            �            1259    18229    notificacao_postagem    TABLE     �   CREATE TABLE notificacao_postagem (
    id_postagem bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL,
    id bigint NOT NULL
);
 (   DROP TABLE public.notificacao_postagem;
       public         postgres    false    4                       1255    18411 7   _verificar_notificacao_postagem(bigint, bigint, bigint)    FUNCTION     l  CREATE FUNCTION _verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint) RETURNS SETOF notificacao_postagem
    LANGUAGE plpgsql
    AS $$
    	begin
        	return query select * from notificacao_postagem where id_destinatario = _id_destinatario
            and id > _pre_start and is_pendente limit _limit;      
		end
    $$;
 q   DROP FUNCTION public._verificar_notificacao_postagem(_id_destinatario bigint, _pre_start bigint, _limit bigint);
       public       postgres    false    219    1    4            *           1255    18438 >   atualizardenuncias(bigint, bigint, integer, character varying)    FUNCTION       CREATE FUNCTION atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS TABLE(id_denuncia bigint, is_suspenso boolean)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            total_denuncias integer;
    	begin
        	select id into newId from registrarDenuncia(
    			_id_denunciante,
    			_id_postagem,
    			_id_tipo_denuncia,
   				_relato
            ); 
             SELECT count(id) INTO total_denuncias FROM denuncia where denuncia.id_postagem = _id_postagem;
            if(total_denuncias > 49) then
            	update postagem set postagem.is_suspenso = true;
            end if;
           	return query select newId, total_denuncias > 49;        
		end
    $$;
 �   DROP FUNCTION public.atualizardenuncias(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4                       1255    18276 #   registraravaliacao(bigint, integer)    FUNCTION     ^  CREATE FUNCTION registraravaliacao(_id_membro_avaliador bigint, _nota integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
        insert into avaliacao(id_membro_avaliador, nota)
        	values(_id_membro_avaliador, _nota) returning avaliacao.id into newId;  
			return newId;         
		end
    $$;
 U   DROP FUNCTION public.registraravaliacao(_id_membro_avaliador bigint, _nota integer);
       public       postgres    false    4    1            �            1255    18489 5   registraravaliacaocomentario(bigint, bigint, boolean)    FUNCTION     �  CREATE FUNCTION registraravaliacaocomentario(_id_avaliador bigint, _id_comentario bigint, _is_positiva boolean) RETURNS TABLE(_id bigint, acao text)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            retorno_atualizacao text;
    	begin
        select id into newId from avaliacao_comentario 
        	where avaliacao_comentario.id_avaliador = _id_avaliador
            	and avaliacao_comentario.id_comentario = _id_comentario limit 1;
        if(newId is null) then        	
			insert into avaliacao_comentario(id_avaliador, id_comentario,is_positiva)
        		values(_id_avaliador, _id_comentario,_is_positiva) returning avaliacao_comentario.id into newId; 
            if(_is_positiva) then
            	update comentario set avaliacoes_positivas = avaliacoes_positivas + 1 where comentario.id = _id_comentario;
            else
            	update comentario set avaliacoes_negativas = avaliacoes_negativas + 1 where comentario.id = _id_comentario;
            end if;
        	return query select newId, 'REGISTRA';
       	else
        	select atualizacao into retorno_atualizacao from _atualizarAvaliacaoComentario( newId, _id_comentario, _is_positiva) as atualizacao;
        		if(retorno_atualizacao = 'REMOVE') then
            		delete from avaliacao_comentario where avaliacao_comentario.id = newId;
            	end if; 
                return query select newId, retorno_atualizacao;
            end if;
		end
    $$;
 v   DROP FUNCTION public.registraravaliacaocomentario(_id_avaliador bigint, _id_comentario bigint, _is_positiva boolean);
       public       postgres    false    4    1            �            1255    18490 3   registraravaliacaopostagem(bigint, bigint, boolean)    FUNCTION     �  CREATE FUNCTION registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean) RETURNS TABLE(_id bigint, acao text)
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
            retorno_atualizacao text;
    	begin
        	select id into newId from avaliacao_postagem 
        		where avaliacao_postagem.id_avaliador = _id_avaliador
            		and avaliacao_postagem.id_postagem = _id_postagem limit 1;
        	if(newId is null) then        	
				insert into avaliacao_postagem(id_avaliador, id_postagem,is_positiva) values(_id_avaliador, _id_postagem,_is_positiva) returning avaliacao_postagem.id into newId; 
            	if(_is_positiva) then
            		update postagem set avaliacoes_positivas = avaliacoes_positivas + 1 where postagem.id = _id_postagem;
            	else
            		update postagem set avaliacoes_negativas = avaliacoes_negativas + 1 where postagem.id = _id_postagem;
            	end if;
        		return query select newId, 'REGISTRA';
       		else
        		select atualizacao into retorno_atualizacao from _atualizarAvaliacaopostagem( newId, _id_postagem, _is_positiva) as atualizacao;
        		if(retorno_atualizacao = 'REMOVE') then
            		delete from avaliacao_postagem where avaliacao_postagem.id = newId;
            	end if; 
            	return query select newId, retorno_atualizacao;
        	end if;        
		end
    $$;
 r   DROP FUNCTION public.registraravaliacaopostagem(_id_avaliador bigint, _id_postagem bigint, _is_positiva boolean);
       public       postgres    false    1    4            (           1255    18098 8   registrarcategoria(character varying, character varying)    FUNCTION     Z  CREATE FUNCTION registrarcategoria(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into categoria(tipo, descricao)
            values(_tipo, _descricao) returning categoria.id into newId;
			return newId;         
		end
    $$;
 `   DROP FUNCTION public.registrarcategoria(_tipo character varying, _descricao character varying);
       public       postgres    false    4    1            �            1255    18119 *   registrarcategoriapostagem(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarcategoriapostagem(_id_postagem bigint, _id_categoria_partilhada bigint) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into categoria_postagem(id_categoria_partilhada, id_postagem)
            values(_id_categoria_partilhada, _id_postagem) returning categoria_postagem.id into newId;
			return newId;         
		end
    $$;
 g   DROP FUNCTION public.registrarcategoriapostagem(_id_postagem bigint, _id_categoria_partilhada bigint);
       public       postgres    false    1    4            '           1255    18033 K   registrarclassificacaoetaria(character varying, character varying, integer)    FUNCTION     �  CREATE FUNCTION registrarclassificacaoetaria(_tipo character varying, _descricao character varying, _idade integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into classificacao_etaria(tipo, descricao, idade)
            values(_tipo, _descricao, _idade) returning classificacao_etaria.id into newId;
			return newId;         
		end
    $$;
 z   DROP FUNCTION public.registrarclassificacaoetaria(_tipo character varying, _descricao character varying, _idade integer);
       public       postgres    false    1    4            �            1255    18220 6   registrarcomentario(character varying, bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
            insert into comentario(comentario, id_remetente, id_postagem) 
            	values(_comentario, _id_remetente, _id_postagem) returning comentario.id into newId;
			return newId;         
		end
    $$;
 t   DROP FUNCTION public.registrarcomentario(_comentario character varying, _id_remetente bigint, _id_postagem bigint);
       public       postgres    false    1    4                       1255    18221 =   registrardenuncia(bigint, bigint, integer, character varying)    FUNCTION     (  CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
        	select id into newId from denuncia 
            		where denuncia.id_denunciante = _id_denunciante
                    	and denuncia.id_postagem = _id_postagem
                        	and denuncia.id_tipo_denuncia = _id_tipo_denuncia limit 1;
                            
            	if(newId is null) then 
            		insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            			values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
				end if;
            return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem bigint, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4                       1255    18167 H   registrardenuncia(bigint, character varying, integer, character varying)    FUNCTION     �  CREATE FUNCTION registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into denuncia(id_denunciante, id_postagem, id_tipo_denuncia, relato) 
            	values(_id_denunciante, _id_postagem, _id_tipo_denuncia, _relato) returning denuncia.id into newId;
			return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrardenuncia(_id_denunciante bigint, _id_postagem character varying, _id_tipo_denuncia integer, _relato character varying);
       public       postgres    false    1    4                       1255    18200 !   registrarinscrito(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarinscrito(_id_registrando bigint, _id_registrado bigint) RETURNS boolean
    LANGUAGE plpgsql
    AS $$
    	declare
        	isRegistrado bigint;
    	begin 
        	if(_id_registrando <> _id_registrado) then 
            	select _id_registrado into isRegistrado from inscrito 
            		where inscrito.id_registrado = _id_registrado and inscrito.id_registrando = _id_registrando limit 1;                
                if(isRegistrado is null) then
            		insert into inscrito(id_registrando, id_registrado) values(_id_registrando, _id_registrado);
                	return true;
                end if;	
            end if; 
            return false;
		end
    $$;
 W   DROP FUNCTION public.registrarinscrito(_id_registrando bigint, _id_registrado bigint);
       public       postgres    false    4    1                       1255    18223 `   registrarmembro(character varying, date, character, character varying, bytea, character varying)    FUNCTION     �  CREATE FUNCTION registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
            insert into membro(login_name, pass, email, sexo, nascimento, nome)
            values(_login_name, _pass, _email, _sexo, _nascimento, _nome) returning membro.id into newId;
			return newId;         
		end
    $$;
 �   DROP FUNCTION public.registrarmembro(_nome character varying, _nascimento date, _sexo character, _login_name character varying, _pass bytea, _email character varying);
       public       postgres    false    1    4            +           1255    18383 .   registrarnotificacaocomentario(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_comentario(id_comentario, id_destinatario) 
            	values(_id_comentario, _id_destinatario) returning notificacao_comentario.id into newId;
			return newId; 
		end
    $$;
 e   DROP FUNCTION public.registrarnotificacaocomentario(_id_destinatario bigint, _id_comentario bigint);
       public       postgres    false    1    4                       1255    18384 ,   registrarnotificacaopostagem(bigint, bigint)    FUNCTION     �  CREATE FUNCTION registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare        
        	newId bigint;
    	begin 
        	insert into notificacao_postagem(id_postagem, id_destinatario) 
            	values(_id_postagem, _id_destinatario) returning notificacao_postagem.id into newId;
			return newId; 
		end
    $$;
 a   DROP FUNCTION public.registrarnotificacaopostagem(_id_destinatario bigint, _id_postagem bigint);
       public       postgres    false    1    4                       1255    18222 �   registrarpostagem(character varying, character varying[], character varying[], character varying[], character varying, character varying, character varying, integer, bigint)    FUNCTION     �  CREATE FUNCTION registrarpostagem(_descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _palavra_chave character varying, _titulo character varying, _patrocinador character varying, _id_classificacao_etaria integer, _id_membro_postante bigint) RETURNS bigint
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId bigint;
    	begin
            insert into postagem(
                descricao, 
                vetor_url_site,
                vetor_url_video,
                vetor_url_imagem,
                palavra_chave,
                titulo,
                patrocinador,
   				id_classificacao_etaria,
                id_membro_postante
				)
            		values(
                        _descricao, 
                        _vetor_url_site, 
                        _vetor_url_video,
                        _vetor_url_imagem,
                        _palavra_chave, 
                        _titulo, 
                        _patrocinador,
    					_id_classificacao_etaria,
                        _id_membro_postante
                    ) 
            	returning postagem.id into newId;
			return newId;         
		end
    $$;
 T  DROP FUNCTION public.registrarpostagem(_descricao character varying, _vetor_url_site character varying[], _vetor_url_video character varying[], _vetor_url_imagem character varying[], _palavra_chave character varying, _titulo character varying, _patrocinador character varying, _id_classificacao_etaria integer, _id_membro_postante bigint);
       public       postgres    false    1    4            �            1255    18004 9   registrarstatusmembro(integer, character varying, citext)    FUNCTION     y  CREATE FUNCTION registrarstatusmembro(_nivel integer, _descricao character varying, _tipo citext) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into status_membro(nivel, descricao, tipo)
            values(_nivel, _descricao, _tipo) returning status_membro.id into newId;
			return newId;         
		end
    $$;
 h   DROP FUNCTION public.registrarstatusmembro(_nivel integer, _descricao character varying, _tipo citext);
       public       postgres    false    4    1    2    2    4    2    4    2    4    4    2    4                       1255    18163 ;   registrartipodenuncia(character varying, character varying)    FUNCTION     Y  CREATE FUNCTION registrartipodenuncia(_tipo character varying, _descricao character varying) RETURNS integer
    LANGUAGE plpgsql
    AS $$
    	declare
    		newId integer;
    	begin
            insert into tipo_denuncia(tipo, descricao) values(_tipo, _descricao) returning tipo_denuncia.id into newId;
			return newId;         
		end
    $$;
 c   DROP FUNCTION public.registrartipodenuncia(_tipo character varying, _descricao character varying);
       public       postgres    false    1    4            �            1259    17760    avaliacao_comentario    TABLE     �   CREATE TABLE avaliacao_comentario (
    id_avaliador bigint NOT NULL,
    id_comentario bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);
 (   DROP TABLE public.avaliacao_comentario;
       public         postgres    false    4            �            1259    18307    avaliacao_comentario_id_seq    SEQUENCE     }   CREATE SEQUENCE avaliacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.avaliacao_comentario_id_seq;
       public       postgres    false    4    208            '           0    0    avaliacao_comentario_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE avaliacao_comentario_id_seq OWNED BY avaliacao_comentario.id;
            public       postgres    false    221            �            1259    17755    avaliacao_postagem    TABLE     �   CREATE TABLE avaliacao_postagem (
    id_avaliador bigint NOT NULL,
    id_postagem bigint NOT NULL,
    is_positiva boolean NOT NULL,
    id bigint NOT NULL
);
 &   DROP TABLE public.avaliacao_postagem;
       public         postgres    false    4            �            1259    18315    avaliacao_postagem_id_seq    SEQUENCE     {   CREATE SEQUENCE avaliacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.avaliacao_postagem_id_seq;
       public       postgres    false    4    207            (           0    0    avaliacao_postagem_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE avaliacao_postagem_id_seq OWNED BY avaliacao_postagem.id;
            public       postgres    false    222            �            1259    17778 	   categoria    TABLE     y   CREATE TABLE categoria (
    tipo citext NOT NULL,
    descricao character varying NOT NULL,
    id smallint NOT NULL
);
    DROP TABLE public.categoria;
       public         postgres    false    2    2    4    2    4    2    4    4    2    4    4            �            1259    18085    categoria_id_seq    SEQUENCE     �   CREATE SEQUENCE categoria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 '   DROP SEQUENCE public.categoria_id_seq;
       public       postgres    false    4    209            )           0    0    categoria_id_seq    SEQUENCE OWNED BY     7   ALTER SEQUENCE categoria_id_seq OWNED BY categoria.id;
            public       postgres    false    217            �            1259    18070    categoria_postagem    TABLE     �   CREATE TABLE categoria_postagem (
    id bigint NOT NULL,
    id_categoria_partilhada smallint NOT NULL,
    id_postagem bigint NOT NULL
);
 &   DROP TABLE public.categoria_postagem;
       public         postgres    false    4            �            1259    18068 "   categoria_postagem_id_postagem_seq    SEQUENCE     �   CREATE SEQUENCE categoria_postagem_id_postagem_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 9   DROP SEQUENCE public.categoria_postagem_id_postagem_seq;
       public       postgres    false    216    4            *           0    0 "   categoria_postagem_id_postagem_seq    SEQUENCE OWNED BY     [   ALTER SEQUENCE categoria_postagem_id_postagem_seq OWNED BY categoria_postagem.id_postagem;
            public       postgres    false    215            �            1259    18066    categoria_postagem_id_seq    SEQUENCE     {   CREATE SEQUENCE categoria_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 0   DROP SEQUENCE public.categoria_postagem_id_seq;
       public       postgres    false    4    216            +           0    0    categoria_postagem_id_seq    SEQUENCE OWNED BY     I   ALTER SEQUENCE categoria_postagem_id_seq OWNED BY categoria_postagem.id;
            public       postgres    false    214            �            1259    17786    classificacao_etaria    TABLE     �   CREATE TABLE classificacao_etaria (
    tipo citext NOT NULL,
    descricao character varying NOT NULL,
    idade smallint NOT NULL,
    id smallint NOT NULL
);
 (   DROP TABLE public.classificacao_etaria;
       public         postgres    false    2    2    4    2    4    2    4    4    2    4    4            �            1259    18015    classificacao_etaria_id_seq    SEQUENCE     �   CREATE SEQUENCE classificacao_etaria_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.classificacao_etaria_id_seq;
       public       postgres    false    4    210            ,           0    0    classificacao_etaria_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE classificacao_etaria_id_seq OWNED BY classificacao_etaria.id;
            public       postgres    false    212            �            1259    17718 
   comentario    TABLE     ~  CREATE TABLE comentario (
    id bigint NOT NULL,
    is_editado boolean DEFAULT false NOT NULL,
    data_comentario timestamp(4) with time zone DEFAULT (now())::date NOT NULL,
    comentario citext NOT NULL,
    id_postagem bigint NOT NULL,
    id_remetente bigint NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);
    DROP TABLE public.comentario;
       public         postgres    false    2    2    4    2    4    2    4    4    2    4    4            �            1259    17716    comentario_id_seq    SEQUENCE     s   CREATE SEQUENCE comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 (   DROP SEQUENCE public.comentario_id_seq;
       public       postgres    false    203    4            -           0    0    comentario_id_seq    SEQUENCE OWNED BY     9   ALTER SEQUENCE comentario_id_seq OWNED BY comentario.id;
            public       postgres    false    202            �            1259    17710    denuncia    TABLE       CREATE TABLE denuncia (
    id bigint NOT NULL,
    id_denunciante bigint NOT NULL,
    id_postagem bigint NOT NULL,
    id_tipo_denuncia smallint NOT NULL,
    relato character varying(300),
    data_denuncia timestamp(4) with time zone DEFAULT now() NOT NULL
);
    DROP TABLE public.denuncia;
       public         postgres    false    4            �            1259    17708    denuncia_id_seq    SEQUENCE     q   CREATE SEQUENCE denuncia_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.denuncia_id_seq;
       public       postgres    false    201    4            .           0    0    denuncia_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE denuncia_id_seq OWNED BY denuncia.id;
            public       postgres    false    200            �            1259    18043    inscrito    TABLE        CREATE TABLE inscrito (
    id_registrando bigint NOT NULL,
    id_registrado bigint NOT NULL,
    data_inscricao date DEFAULT (now())::date NOT NULL,
    CONSTRAINT check_inscrito_registrando_difere_registrado CHECK ((id_registrando <> id_registrado))
);
    DROP TABLE public.inscrito;
       public         postgres    false    4            �            1259    17567    membro    TABLE     �  CREATE TABLE membro (
    login_name citext NOT NULL,
    pass bytea NOT NULL,
    email citext NOT NULL,
    is_suspenso boolean DEFAULT false NOT NULL,
    is_banido boolean DEFAULT false NOT NULL,
    sexo "char" NOT NULL,
    nascimento date NOT NULL,
    nome citext NOT NULL,
    id bigint NOT NULL,
    id_status_membro smallint DEFAULT 1 NOT NULL,
    total_inscritos integer DEFAULT 0 NOT NULL
);
    DROP TABLE public.membro;
       public         postgres    false    2    2    4    2    4    2    4    4    2    4    2    2    4    2    4    2    4    4    2    4    4    2    2    4    2    4    2    4    4    2    4            �            1259    17603    membro_id_seq    SEQUENCE     o   CREATE SEQUENCE membro_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 $   DROP SEQUENCE public.membro_id_seq;
       public       postgres    false    4    197            /           0    0    membro_id_seq    SEQUENCE OWNED BY     1   ALTER SEQUENCE membro_id_seq OWNED BY membro.id;
            public       postgres    false    198            �            1259    18244    notificacao_comentario    TABLE     �   CREATE TABLE notificacao_comentario (
    id bigint NOT NULL,
    id_comentario bigint NOT NULL,
    id_destinatario bigint NOT NULL,
    is_pendente boolean DEFAULT true NOT NULL
);
 *   DROP TABLE public.notificacao_comentario;
       public         postgres    false    4            �            1259    18348    notificacao_comentario_id_seq    SEQUENCE        CREATE SEQUENCE notificacao_comentario_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 4   DROP SEQUENCE public.notificacao_comentario_id_seq;
       public       postgres    false    4    220            0           0    0    notificacao_comentario_id_seq    SEQUENCE OWNED BY     Q   ALTER SEQUENCE notificacao_comentario_id_seq OWNED BY notificacao_comentario.id;
            public       postgres    false    223            �            1259    18385    notificacao_postagem_id_seq    SEQUENCE     }   CREATE SEQUENCE notificacao_postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 2   DROP SEQUENCE public.notificacao_postagem_id_seq;
       public       postgres    false    219    4            1           0    0    notificacao_postagem_id_seq    SEQUENCE OWNED BY     M   ALTER SEQUENCE notificacao_postagem_id_seq OWNED BY notificacao_postagem.id;
            public       postgres    false    224            �            1259    17730    postagem    TABLE     �  CREATE TABLE postagem (
    id bigint NOT NULL,
    descricao citext,
    vetor_url_site character varying(10)[],
    vetor_url_video character varying(10)[],
    vetor_url_imagem character varying(10)[],
    palavra_chave citext,
    titulo citext NOT NULL,
    patrocinador character varying(200),
    id_classificacao_etaria smallint NOT NULL,
    id_membro_postante bigint NOT NULL,
    data_postagem timestamp(4) with time zone DEFAULT now() NOT NULL,
    visualizacoes bigint DEFAULT 0 NOT NULL,
    is_suspensa boolean DEFAULT false NOT NULL,
    avaliacoes_positivas bigint DEFAULT 0 NOT NULL,
    avaliacoes_negativas bigint DEFAULT 0 NOT NULL
);
    DROP TABLE public.postagem;
       public         postgres    false    2    2    4    2    4    2    4    4    2    4    2    2    4    2    4    2    4    4    2    4    4    2    2    4    2    4    2    4    4    2    4            �            1259    17728    postagem_id_seq    SEQUENCE     q   CREATE SEQUENCE postagem_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 &   DROP SEQUENCE public.postagem_id_seq;
       public       postgres    false    4    205            2           0    0    postagem_id_seq    SEQUENCE OWNED BY     5   ALTER SEQUENCE postagem_id_seq OWNED BY postagem.id;
            public       postgres    false    204            �            1259    17700    status_membro    TABLE     �   CREATE TABLE status_membro (
    nivel smallint NOT NULL,
    descricao character varying NOT NULL,
    tipo citext NOT NULL,
    id smallint NOT NULL
);
 !   DROP TABLE public.status_membro;
       public         postgres    false    4    2    2    4    2    4    2    4    4    2    4            �            1259    17986    status_membro_id_seq    SEQUENCE     �   CREATE SEQUENCE status_membro_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.status_membro_id_seq;
       public       postgres    false    199    4            3           0    0    status_membro_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE status_membro_id_seq OWNED BY status_membro.id;
            public       postgres    false    211            �            1259    17739    tipo_denuncia    TABLE     r   CREATE TABLE tipo_denuncia (
    id smallint NOT NULL,
    tipo citext NOT NULL,
    descricao citext NOT NULL
);
 !   DROP TABLE public.tipo_denuncia;
       public         postgres    false    4    2    2    4    2    4    2    4    4    2    4    2    2    4    2    4    2    4    4    2    4            �            1259    18147    tipo_denuncia_id_seq    SEQUENCE     �   CREATE SEQUENCE tipo_denuncia_id_seq
    AS smallint
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;
 +   DROP SEQUENCE public.tipo_denuncia_id_seq;
       public       postgres    false    4    206            4           0    0    tipo_denuncia_id_seq    SEQUENCE OWNED BY     ?   ALTER SEQUENCE tipo_denuncia_id_seq OWNED BY tipo_denuncia.id;
            public       postgres    false    218            A           2604    18309    avaliacao_comentario id    DEFAULT     t   ALTER TABLE ONLY avaliacao_comentario ALTER COLUMN id SET DEFAULT nextval('avaliacao_comentario_id_seq'::regclass);
 F   ALTER TABLE public.avaliacao_comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    221    208            @           2604    18317    avaliacao_postagem id    DEFAULT     p   ALTER TABLE ONLY avaliacao_postagem ALTER COLUMN id SET DEFAULT nextval('avaliacao_postagem_id_seq'::regclass);
 D   ALTER TABLE public.avaliacao_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    222    207            B           2604    18087    categoria id    DEFAULT     ^   ALTER TABLE ONLY categoria ALTER COLUMN id SET DEFAULT nextval('categoria_id_seq'::regclass);
 ;   ALTER TABLE public.categoria ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    217    209            G           2604    18115    categoria_postagem id    DEFAULT     p   ALTER TABLE ONLY categoria_postagem ALTER COLUMN id SET DEFAULT nextval('categoria_postagem_id_seq'::regclass);
 D   ALTER TABLE public.categoria_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    214    216    216            F           2604    18074    categoria_postagem id_postagem    DEFAULT     �   ALTER TABLE ONLY categoria_postagem ALTER COLUMN id_postagem SET DEFAULT nextval('categoria_postagem_id_postagem_seq'::regclass);
 M   ALTER TABLE public.categoria_postagem ALTER COLUMN id_postagem DROP DEFAULT;
       public       postgres    false    215    216    216            C           2604    18017    classificacao_etaria id    DEFAULT     t   ALTER TABLE ONLY classificacao_etaria ALTER COLUMN id SET DEFAULT nextval('classificacao_etaria_id_seq'::regclass);
 F   ALTER TABLE public.classificacao_etaria ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    212    210            4           2604    17725    comentario id    DEFAULT     `   ALTER TABLE ONLY comentario ALTER COLUMN id SET DEFAULT nextval('comentario_id_seq'::regclass);
 <   ALTER TABLE public.comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    203    202    203            2           2604    17713    denuncia id    DEFAULT     \   ALTER TABLE ONLY denuncia ALTER COLUMN id SET DEFAULT nextval('denuncia_id_seq'::regclass);
 :   ALTER TABLE public.denuncia ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    200    201    201            +           2604    17605 	   membro id    DEFAULT     X   ALTER TABLE ONLY membro ALTER COLUMN id SET DEFAULT nextval('membro_id_seq'::regclass);
 8   ALTER TABLE public.membro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    198    197            J           2604    18350    notificacao_comentario id    DEFAULT     x   ALTER TABLE ONLY notificacao_comentario ALTER COLUMN id SET DEFAULT nextval('notificacao_comentario_id_seq'::regclass);
 H   ALTER TABLE public.notificacao_comentario ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    223    220            I           2604    18387    notificacao_postagem id    DEFAULT     t   ALTER TABLE ONLY notificacao_postagem ALTER COLUMN id SET DEFAULT nextval('notificacao_postagem_id_seq'::regclass);
 F   ALTER TABLE public.notificacao_postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    224    219            9           2604    17733    postagem id    DEFAULT     \   ALTER TABLE ONLY postagem ALTER COLUMN id SET DEFAULT nextval('postagem_id_seq'::regclass);
 :   ALTER TABLE public.postagem ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    204    205    205            1           2604    17988    status_membro id    DEFAULT     f   ALTER TABLE ONLY status_membro ALTER COLUMN id SET DEFAULT nextval('status_membro_id_seq'::regclass);
 ?   ALTER TABLE public.status_membro ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    211    199            ?           2604    18149    tipo_denuncia id    DEFAULT     f   ALTER TABLE ONLY tipo_denuncia ALTER COLUMN id SET DEFAULT nextval('tipo_denuncia_id_seq'::regclass);
 ?   ALTER TABLE public.tipo_denuncia ALTER COLUMN id DROP DEFAULT;
       public       postgres    false    218    206                      0    17760    avaliacao_comentario 
   TABLE DATA               U   COPY avaliacao_comentario (id_avaliador, id_comentario, is_positiva, id) FROM stdin;
    public       postgres    false    208   �                0    17755    avaliacao_postagem 
   TABLE DATA               Q   COPY avaliacao_postagem (id_avaliador, id_postagem, is_positiva, id) FROM stdin;
    public       postgres    false    207   �                0    17778 	   categoria 
   TABLE DATA               1   COPY categoria (tipo, descricao, id) FROM stdin;
    public       postgres    false    209   �                0    18070    categoria_postagem 
   TABLE DATA               O   COPY categoria_postagem (id, id_categoria_partilhada, id_postagem) FROM stdin;
    public       postgres    false    216   �                0    17786    classificacao_etaria 
   TABLE DATA               C   COPY classificacao_etaria (tipo, descricao, idade, id) FROM stdin;
    public       postgres    false    210   �      	          0    17718 
   comentario 
   TABLE DATA               �   COPY comentario (id, is_editado, data_comentario, comentario, id_postagem, id_remetente, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
    public       postgres    false    203                   0    17710    denuncia 
   TABLE DATA               e   COPY denuncia (id, id_denunciante, id_postagem, id_tipo_denuncia, relato, data_denuncia) FROM stdin;
    public       postgres    false    201   /                0    18043    inscrito 
   TABLE DATA               J   COPY inscrito (id_registrando, id_registrado, data_inscricao) FROM stdin;
    public       postgres    false    213   L                0    17567    membro 
   TABLE DATA               �   COPY membro (login_name, pass, email, is_suspenso, is_banido, sexo, nascimento, nome, id, id_status_membro, total_inscritos) FROM stdin;
    public       postgres    false    197   i                0    18244    notificacao_comentario 
   TABLE DATA               Z   COPY notificacao_comentario (id, id_comentario, id_destinatario, is_pendente) FROM stdin;
    public       postgres    false    220   �                0    18229    notificacao_postagem 
   TABLE DATA               V   COPY notificacao_postagem (id_postagem, id_destinatario, is_pendente, id) FROM stdin;
    public       postgres    false    219   �                0    17730    postagem 
   TABLE DATA                 COPY postagem (id, descricao, vetor_url_site, vetor_url_video, vetor_url_imagem, palavra_chave, titulo, patrocinador, id_classificacao_etaria, id_membro_postante, data_postagem, visualizacoes, is_suspensa, avaliacoes_positivas, avaliacoes_negativas) FROM stdin;
    public       postgres    false    205   �                0    17700    status_membro 
   TABLE DATA               <   COPY status_membro (nivel, descricao, tipo, id) FROM stdin;
    public       postgres    false    199   �                0    17739    tipo_denuncia 
   TABLE DATA               5   COPY tipo_denuncia (id, tipo, descricao) FROM stdin;
    public       postgres    false    206   �      5           0    0    avaliacao_comentario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('avaliacao_comentario_id_seq', 112, true);
            public       postgres    false    221            6           0    0    avaliacao_postagem_id_seq    SEQUENCE SET     A   SELECT pg_catalog.setval('avaliacao_postagem_id_seq', 92, true);
            public       postgres    false    222            7           0    0    categoria_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('categoria_id_seq', 10, true);
            public       postgres    false    217            8           0    0 "   categoria_postagem_id_postagem_seq    SEQUENCE SET     J   SELECT pg_catalog.setval('categoria_postagem_id_postagem_seq', 1, false);
            public       postgres    false    215            9           0    0    categoria_postagem_id_seq    SEQUENCE SET     @   SELECT pg_catalog.setval('categoria_postagem_id_seq', 1, true);
            public       postgres    false    214            :           0    0    classificacao_etaria_id_seq    SEQUENCE SET     B   SELECT pg_catalog.setval('classificacao_etaria_id_seq', 1, true);
            public       postgres    false    212            ;           0    0    comentario_id_seq    SEQUENCE SET     8   SELECT pg_catalog.setval('comentario_id_seq', 6, true);
            public       postgres    false    202            <           0    0    denuncia_id_seq    SEQUENCE SET     6   SELECT pg_catalog.setval('denuncia_id_seq', 9, true);
            public       postgres    false    200            =           0    0    membro_id_seq    SEQUENCE SET     5   SELECT pg_catalog.setval('membro_id_seq', 17, true);
            public       postgres    false    198            >           0    0    notificacao_comentario_id_seq    SEQUENCE SET     D   SELECT pg_catalog.setval('notificacao_comentario_id_seq', 4, true);
            public       postgres    false    223            ?           0    0    notificacao_postagem_id_seq    SEQUENCE SET     C   SELECT pg_catalog.setval('notificacao_postagem_id_seq', 25, true);
            public       postgres    false    224            @           0    0    postagem_id_seq    SEQUENCE SET     7   SELECT pg_catalog.setval('postagem_id_seq', 34, true);
            public       postgres    false    204            A           0    0    status_membro_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('status_membro_id_seq', 6, true);
            public       postgres    false    211            B           0    0    tipo_denuncia_id_seq    SEQUENCE SET     ;   SELECT pg_catalog.setval('tipo_denuncia_id_seq', 3, true);
            public       postgres    false    218            e           2606    18314 .   avaliacao_comentario avaliacao_comentario_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT avaliacao_comentario_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT avaliacao_comentario_pkey;
       public         postgres    false    208            c           2606    18322 *   avaliacao_postagem avaliacao_postagem_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT avaliacao_postagem_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT avaliacao_postagem_pkey;
       public         postgres    false    207            g           2606    18095    categoria categoria_pkey 
   CONSTRAINT     O   ALTER TABLE ONLY categoria
    ADD CONSTRAINT categoria_pkey PRIMARY KEY (id);
 B   ALTER TABLE ONLY public.categoria DROP CONSTRAINT categoria_pkey;
       public         postgres    false    209            q           2606    18117 *   categoria_postagem categoria_postagem_pkey 
   CONSTRAINT     a   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT categoria_postagem_pkey PRIMARY KEY (id);
 T   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT categoria_postagem_pkey;
       public         postgres    false    216            0           2606    18427    membro check_membro_menor_idade    CHECK CONSTRAINT     �   ALTER TABLE membro
    ADD CONSTRAINT check_membro_menor_idade CHECK ((date_part('years'::text, age((nascimento)::timestamp with time zone)) > (17)::double precision)) NOT VALID;
 D   ALTER TABLE public.membro DROP CONSTRAINT check_membro_menor_idade;
       public       postgres    false    197    197            k           2606    18027 .   classificacao_etaria classificacao_etaria_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT classificacao_etaria_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT classificacao_etaria_pkey;
       public         postgres    false    210            [           2606    17727    comentario comentario_pkey 
   CONSTRAINT     Q   ALTER TABLE ONLY comentario
    ADD CONSTRAINT comentario_pkey PRIMARY KEY (id);
 D   ALTER TABLE ONLY public.comentario DROP CONSTRAINT comentario_pkey;
       public         postgres    false    203            Y           2606    17715    denuncia denuncia_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT denuncia_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT denuncia_pkey;
       public         postgres    false    201            M           2606    17613    membro membro_pkey 
   CONSTRAINT     I   ALTER TABLE ONLY membro
    ADD CONSTRAINT membro_pkey PRIMARY KEY (id);
 <   ALTER TABLE ONLY public.membro DROP CONSTRAINT membro_pkey;
       public         postgres    false    197            u           2606    18355 2   notificacao_comentario notificacao_comentario_pkey 
   CONSTRAINT     i   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT notificacao_comentario_pkey PRIMARY KEY (id);
 \   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT notificacao_comentario_pkey;
       public         postgres    false    220            s           2606    18392 .   notificacao_postagem notificacao_postagem_pkey 
   CONSTRAINT     e   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT notificacao_postagem_pkey PRIMARY KEY (id);
 X   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT notificacao_postagem_pkey;
       public         postgres    false    219            ]           2606    17738    postagem postagem_pkey 
   CONSTRAINT     M   ALTER TABLE ONLY postagem
    ADD CONSTRAINT postagem_pkey PRIMARY KEY (id);
 @   ALTER TABLE ONLY public.postagem DROP CONSTRAINT postagem_pkey;
       public         postgres    false    205            S           2606    17998     status_membro status_membro_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_pkey;
       public         postgres    false    199            U           2606    17960 (   status_membro status_membro_unique_nivel 
   CONSTRAINT     ]   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_nivel UNIQUE (nivel);
 R   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_nivel;
       public         postgres    false    199            W           2606    17962 '   status_membro status_membro_unique_tipo 
   CONSTRAINT     [   ALTER TABLE ONLY status_membro
    ADD CONSTRAINT status_membro_unique_tipo UNIQUE (tipo);
 Q   ALTER TABLE ONLY public.status_membro DROP CONSTRAINT status_membro_unique_tipo;
       public         postgres    false    199            _           2606    18157     tipo_denuncia tipo_denuncia_pkey 
   CONSTRAINT     W   ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT tipo_denuncia_pkey PRIMARY KEY (id);
 J   ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT tipo_denuncia_pkey;
       public         postgres    false    206            i           2606    18097    categoria unique_categoria_tipo 
   CONSTRAINT     S   ALTER TABLE ONLY categoria
    ADD CONSTRAINT unique_categoria_tipo UNIQUE (tipo);
 I   ALTER TABLE ONLY public.categoria DROP CONSTRAINT unique_categoria_tipo;
       public         postgres    false    209            m           2606    18009 6   classificacao_etaria unique_classificacao_etaria_idade 
   CONSTRAINT     k   ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT unique_classificacao_etaria_idade UNIQUE (idade);
 `   ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT unique_classificacao_etaria_idade;
       public         postgres    false    210            o           2606    18007 5   classificacao_etaria unique_classificacao_etaria_tipo 
   CONSTRAINT     i   ALTER TABLE ONLY classificacao_etaria
    ADD CONSTRAINT unique_classificacao_etaria_tipo UNIQUE (tipo);
 _   ALTER TABLE ONLY public.classificacao_etaria DROP CONSTRAINT unique_classificacao_etaria_tipo;
       public         postgres    false    210            O           2606    17956    membro unique_membro_email 
   CONSTRAINT     O   ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_email UNIQUE (email);
 D   ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_email;
       public         postgres    false    197            Q           2606    17954    membro unique_membro_login_name 
   CONSTRAINT     Y   ALTER TABLE ONLY membro
    ADD CONSTRAINT unique_membro_login_name UNIQUE (login_name);
 I   ALTER TABLE ONLY public.membro DROP CONSTRAINT unique_membro_login_name;
       public         postgres    false    197            a           2606    18159 "   tipo_denuncia unique_tipo_denuncia 
   CONSTRAINT     V   ALTER TABLE ONLY tipo_denuncia
    ADD CONSTRAINT unique_tipo_denuncia UNIQUE (tipo);
 L   ALTER TABLE ONLY public.tipo_denuncia DROP CONSTRAINT unique_tipo_denuncia;
       public         postgres    false    206            �           2606    18283 ,   avaliacao_comentario fk_avaliacao_comentario    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);
 V   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario;
       public       postgres    false    203    2907    208            �           2606    18278 =   avaliacao_comentario fk_avaliacao_comentario_membro_avaliador    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_comentario
    ADD CONSTRAINT fk_avaliacao_comentario_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);
 g   ALTER TABLE ONLY public.avaliacao_comentario DROP CONSTRAINT fk_avaliacao_comentario_membro_avaliador;
       public       postgres    false    2893    197    208            ~           2606    18478 (   avaliacao_postagem fk_avaliacao_postagem    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 R   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem;
       public       postgres    false    207    2909    205                       2606    18483 9   avaliacao_postagem fk_avaliacao_postagem_membro_avaliador    FK CONSTRAINT     �   ALTER TABLE ONLY avaliacao_postagem
    ADD CONSTRAINT fk_avaliacao_postagem_membro_avaliador FOREIGN KEY (id_avaliador) REFERENCES membro(id);
 c   ALTER TABLE ONLY public.avaliacao_postagem DROP CONSTRAINT fk_avaliacao_postagem_membro_avaliador;
       public       postgres    false    197    207    2893            �           2606    18110 *   categoria_postagem fk_categoria_partilhada    FK CONSTRAINT     �   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_partilhada FOREIGN KEY (id_categoria_partilhada) REFERENCES categoria(id);
 T   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_partilhada;
       public       postgres    false    216    2919    209            �           2606    18104 2   categoria_postagem fk_categoria_postagem_categoria    FK CONSTRAINT     �   ALTER TABLE ONLY categoria_postagem
    ADD CONSTRAINT fk_categoria_postagem_categoria FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 \   ALTER TABLE ONLY public.categoria_postagem DROP CONSTRAINT fk_categoria_postagem_categoria;
       public       postgres    false    216    2909    205            w           2606    17809 '   denuncia fk_denuncia_membro_denunciante    FK CONSTRAINT     �   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_membro_denunciante FOREIGN KEY (id_denunciante) REFERENCES membro(id);
 Q   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_membro_denunciante;
       public       postgres    false    197    2893    201            x           2606    17814    denuncia fk_denuncia_postagem    FK CONSTRAINT     u   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 G   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_postagem;
       public       postgres    false    201    205    2909            y           2606    18169 "   denuncia fk_denuncia_tipo_denuncia    FK CONSTRAINT     �   ALTER TABLE ONLY denuncia
    ADD CONSTRAINT fk_denuncia_tipo_denuncia FOREIGN KEY (id_tipo_denuncia) REFERENCES tipo_denuncia(id);
 L   ALTER TABLE ONLY public.denuncia DROP CONSTRAINT fk_denuncia_tipo_denuncia;
       public       postgres    false    2911    206    201            �           2606    18052    inscrito fk_id_registrado    FK CONSTRAINT     r   ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrado FOREIGN KEY (id_registrando) REFERENCES membro(id);
 C   ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrado;
       public       postgres    false    2893    197    213            �           2606    18047    inscrito fk_id_registrando    FK CONSTRAINT     s   ALTER TABLE ONLY inscrito
    ADD CONSTRAINT fk_id_registrando FOREIGN KEY (id_registrando) REFERENCES membro(id);
 D   ALTER TABLE ONLY public.inscrito DROP CONSTRAINT fk_id_registrando;
       public       postgres    false    2893    197    213            v           2606    17999    membro fk_membro_status_membro    FK CONSTRAINT     �   ALTER TABLE ONLY membro
    ADD CONSTRAINT fk_membro_status_membro FOREIGN KEY (id_status_membro) REFERENCES status_membro(id);
 H   ALTER TABLE ONLY public.membro DROP CONSTRAINT fk_membro_status_membro;
       public       postgres    false    2899    197    199            �           2606    18356 0   notificacao_comentario fk_notificacao_comentario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_comentario FOREIGN KEY (id_comentario) REFERENCES comentario(id);
 Z   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_comentario;
       public       postgres    false    2907    203    220            �           2606    18361 9   notificacao_comentario fk_notificacao_membro_destinatario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_comentario
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);
 c   ALTER TABLE ONLY public.notificacao_comentario DROP CONSTRAINT fk_notificacao_membro_destinatario;
       public       postgres    false    197    220    2893            �           2606    18373 7   notificacao_postagem fk_notificacao_membro_destinatario    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_membro_destinatario FOREIGN KEY (id_destinatario) REFERENCES membro(id);
 a   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_membro_destinatario;
       public       postgres    false    2893    219    197            �           2606    18398 ,   notificacao_postagem fk_notificacao_postagem    FK CONSTRAINT     �   ALTER TABLE ONLY notificacao_postagem
    ADD CONSTRAINT fk_notificacao_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 V   ALTER TABLE ONLY public.notificacao_postagem DROP CONSTRAINT fk_notificacao_postagem;
       public       postgres    false    205    2909    219            }           2606    18028 (   postagem fk_postagem_classificaca_etaria    FK CONSTRAINT     �   ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_classificaca_etaria FOREIGN KEY (id_classificacao_etaria) REFERENCES classificacao_etaria(id);
 R   ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_classificaca_etaria;
       public       postgres    false    210    205    2923            |           2606    17968 $   postagem fk_postagem_membro_postante    FK CONSTRAINT     �   ALTER TABLE ONLY postagem
    ADD CONSTRAINT fk_postagem_membro_postante FOREIGN KEY (id_membro_postante) REFERENCES membro(id);
 N   ALTER TABLE ONLY public.postagem DROP CONSTRAINT fk_postagem_membro_postante;
       public       postgres    false    205    197    2893            {           2606    17829 )   comentario id_comentario_membro_remetente    FK CONSTRAINT     �   ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_membro_remetente FOREIGN KEY (id_remetente) REFERENCES membro(id);
 S   ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_membro_remetente;
       public       postgres    false    2893    197    203            z           2606    17824 !   comentario id_comentario_postagem    FK CONSTRAINT     y   ALTER TABLE ONLY comentario
    ADD CONSTRAINT id_comentario_postagem FOREIGN KEY (id_postagem) REFERENCES postagem(id);
 K   ALTER TABLE ONLY public.comentario DROP CONSTRAINT id_comentario_postagem;
       public       postgres    false    205    203    2909                  x������ � �            x������ � �            x������ � �            x������ � �            x������ � �      	      x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �            x������ � �     