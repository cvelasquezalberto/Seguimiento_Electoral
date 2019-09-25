package com.servicio.externo.mail;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.mail.MailException;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.mail.javamail.MimeMessagePreparator;
import org.springframework.stereotype.Component;
import org.springframework.web.server.ResponseStatusException;

@Component	
public class MailService {
	@Autowired
    public JavaMailSender emailSender;
	
	@Autowired
	public MailContentBuilder mailContentBuilder;

	public void enviarCorreoRegistroUsuario(String correo, String usuario) {
        MimeMessagePreparator messagePreparator = mimeMessage -> {
            MimeMessageHelper messageHelper = new MimeMessageHelper(mimeMessage);
            messageHelper.setFrom("crisvelasquez02@gmail.com");
            messageHelper.setTo(correo);
            messageHelper.setSubject("Seguimiento Electoral");
            String content = mailContentBuilder.build(usuario);
            messageHelper.setText(content, true);
        };
        try {
        	emailSender.send(messagePreparator);
        } catch (MailException e) {
        	throw new ResponseStatusException(HttpStatus.NOT_FOUND, e.getMessage());
        }
    }
	
    public void sendSimpleMessage(String to, String subject, String text) throws Exception {
        try {
            SimpleMailMessage message = new SimpleMailMessage();
            message.setTo(to);
            message.setSubject(subject);
            message.setText(text);
            emailSender.send(message);
        } catch (Exception exception) {
            throw new Exception("Error en el envío de correo");
        }
    }
}
